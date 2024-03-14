name: Run Terraform
on:
  push:
    branches:
     - main
  pull_request:
    branches:
     - main
  workflow_dispatch:

permissions:
  id-token: write
  contents: read
  pull-requests: write
  security-events: write

jobs:
  analysis:
    if: github.event_name == 'pull_request'
    name: Analyse the Terraform
    environment: dev
    runs-on: ubuntu-22.04
    env:
      ARM_CLIENT_ID: "${{ vars.AZURE_CLIENT_ID }}"
      ARM_SUBSCRIPTION_ID: "${{ vars.AZURE_SUBSCRIPTION_ID }}"
      ARM_TENANT_ID: "${{ vars.AZURE_TENANT_ID }}"
    steps:

    ############################################################################

    - name: Checkout Code
      # https://github.com/actions/checkout/releases
      uses: actions/checkout@9bb56186c3b09b4f86b1c65136769dd318469633 # v4.1.2

    ############################################################################

    - name: Run Trivy vulnerability scanner (Git repo)
      # https://github.com/aquasecurity/trivy-action/releases
      uses: aquasecurity/trivy-action@062f2592684a31eb3aa050cc61e7ca1451cecd3d # v0.18.0
      with:
        scan-type: 'fs'
        format: 'sarif'
        output: 'trivy-results-fs.sarif'
        exit-code: '1'
        ignore-unfixed: true
        severity: 'CRITICAL'

    - name: Upload Trivy scan results (Git repo)
      # https://github.com/github/codeql-action/releases
      uses: github/codeql-action/upload-sarif@v2.16.4
      with:
        sarif_file: 'trivy-results-fs.sarif'

    - name: Run Trivy vulnerability scanner (IaC)
      # https://github.com/aquasecurity/trivy-action/releases
      uses: aquasecurity/trivy-action@062f2592684a31eb3aa050cc61e7ca1451cecd3d # v0.18.0
      with:
        scan-type: 'config'
        hide-progress: false
        format: 'sarif'
        output: 'trivy-results-config.sarif'
        exit-code: '1'
        ignore-unfixed: true
        severity: 'CRITICAL,HIGH'

    - name: Upload Trivy scan results (IaC)
      # https://github.com/github/codeql-action/releases
      uses: github/codeql-action/upload-sarif@v2.16.4
      with:
        sarif_file: 'trivy-results-config.sarif'

    - name: Run Trivy SBOM generator
      # https://github.com/aquasecurity/trivy-action/releases
      uses: aquasecurity/trivy-action@062f2592684a31eb3aa050cc61e7ca1451cecd3d # v0.18.0
      with:
        scan-type: 'fs'
        format: 'github'
        output: 'dependency-results.sbom.json'
        image-ref: '.'
        github-pat: ${{ secrets.GITHUB_TOKEN }}

    ############################################################################

    - name: tfsec
      # https://github.com/aquasecurity/tfsec-pr-commenter-action/releases
      uses: aquasecurity/tfsec-pr-commenter-action@7a44c5dcde5dfab737363e391800629e27b6376b # v1.3.1
      with:
        tfsec_args: --soft-fail
        github_token: ${{ github.token }}

    ############################################################################

    - name: Setup Terraform
      # https://github.com/hashicorp/setup-terraform/releases
      uses: hashicorp/setup-terraform@a1502cd9e758c50496cc9ac5308c4843bcd56d36 # v3.0.0
      with:
        terraform_version: "1.7.5"

    - name: Check Terraform formatting
      run: |
        terraform fmt \
          -check

    - name: Initialize Terraform working directory
      run: |
        terraform init \
          -backend-config="resource_group_name=${{vars.BACKEND_AZURE_RESOURCE_GROUP_NAME}}" \
          -backend-config="storage_account_name=${{vars.BACKEND_AZURE_STORAGE_ACCOUNT_NAME}}" \
          -backend-config="container_name=${{vars.BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME}}"

    - name: Validate Terraform configurations
      run: |
        terraform validate \
          -no-color

    - name: Create Terraform execution plan
      id: plan
      run: |
        terraform plan \
          -no-color \
          -input=false \
          -var "resource_group_name=${{vars.AZURE_RESOURCE_GROUP_NAME}}"
      continue-on-error: true

    - name: Update Pull Request
      # https://github.com/actions/github-script/releases
      uses: actions/github-script@60a0d83039c74a4aee543508d2ffcb1c3799cdea # v7.0.1
      env:
        PLAN: "terraform\n${{ steps.plan.outputs.stdout }}"
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }}
        script: |
          const output = `#### Terraform Format and Style 🖌\`${{ steps.fmt.outcome }}\`
          #### Terraform Initialization ⚙️\`${{ steps.init.outcome }}\`
          #### Terraform Validation 🤖\`${{ steps.validate.outcome }}\`
          <details><summary>Validation Output</summary>

          \`\`\`\n
          ${{ steps.validate.outputs.stdout }}
          \`\`\`

          </details>

          #### Terraform Plan 📖\`${{ steps.plan.outcome }}\`

          <details><summary>Show Plan</summary>

          \`\`\`\n
          ${process.env.PLAN}
          \`\`\`

          </details>

          *Pushed by: @${{ github.actor }}, Action: \`${{ github.event_name }}\`*`;

          github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner,
            repo: context.repo.repo,
            body: output
          })

    - name: Exit pipeline on Terraform plan failure
      if: steps.plan.outcome == 'failure'
      run: exit 1

  ##############################################################################

  deploy-to-dev:
    if: github.event_name != 'pull_request'
    name: Deploy to Dev
    environment: dev
    runs-on: ubuntu-22.04
    env:
      ARM_CLIENT_ID: "${{ vars.AZURE_CLIENT_ID }}"
      ARM_SUBSCRIPTION_ID: "${{ vars.AZURE_SUBSCRIPTION_ID }}"
      ARM_TENANT_ID: "${{ vars.AZURE_TENANT_ID }}"
      ARM_USE_AZUREAD: true

    steps:
    - name: Checkout Code
      # https://github.com/actions/checkout/releases
      uses: actions/checkout@9bb56186c3b09b4f86b1c65136769dd318469633 # v4.1.2

    ############################################################################

    - name: Setup Terraform
      # https://github.com/hashicorp/setup-terraform/releases
      uses: hashicorp/setup-terraform@a1502cd9e758c50496cc9ac5308c4843bcd56d36 # v3.0.0
      with:
        terraform_version: "1.7.5"

    - name: Initialize Terraform working directory
      run: |
        terraform init \
          -backend-config="resource_group_name=${{vars.BACKEND_AZURE_RESOURCE_GROUP_NAME}}" \
          -backend-config="storage_account_name=${{vars.BACKEND_AZURE_STORAGE_ACCOUNT_NAME}}" \
          -backend-config="container_name=${{vars.BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME}}"

    - name: Apply Terraform execution plan
      run: |
        terraform apply \
          -auto-approve \
          -var "resource_group_name=${{vars.AZURE_RESOURCE_GROUP_NAME}}"

  ##############################################################################

  deploy-to-test:
    if: github.event_name != 'pull_request'
    needs: deploy-to-dev
    name: Deploy to Test
    environment: test
    runs-on: ubuntu-22.04
    env:
      ARM_CLIENT_ID: "${{ vars.AZURE_CLIENT_ID }}"
      ARM_SUBSCRIPTION_ID: "${{ vars.AZURE_SUBSCRIPTION_ID }}"
      ARM_TENANT_ID: "${{ vars.AZURE_TENANT_ID }}"
      ARM_USE_AZUREAD: true

    steps:
    - name: Checkout Code
      # https://github.com/actions/checkout/releases
      uses: actions/checkout@9bb56186c3b09b4f86b1c65136769dd318469633 # v4.1.2

    ############################################################################

    - name: Setup Terraform
      # https://github.com/hashicorp/setup-terraform/releases
      uses: hashicorp/setup-terraform@a1502cd9e758c50496cc9ac5308c4843bcd56d36 # v3.0.0
      with:
        terraform_version: "1.7.5"

    - name: Initialize Terraform working directory
      run: |
        terraform init \
          -backend-config="resource_group_name=${{vars.BACKEND_AZURE_RESOURCE_GROUP_NAME}}" \
          -backend-config="storage_account_name=${{vars.BACKEND_AZURE_STORAGE_ACCOUNT_NAME}}" \
          -backend-config="container_name=${{vars.BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME}}"

    - name: Apply Terraform execution plan
      run: |
        terraform apply \
          -auto-approve \
          -var "resource_group_name=${{vars.AZURE_RESOURCE_GROUP_NAME}}"

  ##############################################################################

  deploy-to-prod:
    if: github.event_name != 'pull_request'
    needs: deploy-to-test
    name: Deploy to Prod
    environment: prod
    runs-on: ubuntu-22.04
    env:
      ARM_CLIENT_ID: "${{ vars.AZURE_CLIENT_ID }}"
      ARM_SUBSCRIPTION_ID: "${{ vars.AZURE_SUBSCRIPTION_ID }}"
      ARM_TENANT_ID: "${{ vars.AZURE_TENANT_ID }}"
      ARM_USE_AZUREAD: true

    steps:
    - name: Checkout Code
      # https://github.com/actions/checkout/releases
      uses: actions/checkout@9bb56186c3b09b4f86b1c65136769dd318469633 # v4.1.2

    ############################################################################

    - name: Setup Terraform
      # https://github.com/hashicorp/setup-terraform/releases
      uses: hashicorp/setup-terraform@a1502cd9e758c50496cc9ac5308c4843bcd56d36 # v3.0.0
      with:
        terraform_version: "1.7.5"

    - name: Initialize Terraform working directory
      run: |
        terraform init \
          -backend-config="resource_group_name=${{vars.BACKEND_AZURE_RESOURCE_GROUP_NAME}}" \
          -backend-config="storage_account_name=${{vars.BACKEND_AZURE_STORAGE_ACCOUNT_NAME}}" \
          -backend-config="container_name=${{vars.BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME}}"

    - name: Apply Terraform execution plan
      run: |
        terraform apply \
          -auto-approve \
          -var "resource_group_name=${{vars.AZURE_RESOURCE_GROUP_NAME}}"
