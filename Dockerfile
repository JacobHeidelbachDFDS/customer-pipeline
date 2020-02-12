# ========================================
# GENERAL PREREQUISITES
# ========================================

FROM debian:buster-slim

# Explicitly set USER env variable to accomodate issues with golang code being cross-compiled
ENV USER root

RUN apt-get update \
    && apt-get install -y curl unzip git bash-completion jq ssh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Adding  GitHub public SSH key to known hosts
RUN ssh -T -o "StrictHostKeyChecking no" -o "PubkeyAuthentication no" git@github.com || true


# ========================================
# PYTHON
# ========================================

RUN apt-get update \
    && apt-get install -y python python-pip python3 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# ========================================
# AWS CLI
# ========================================

ENV AWSCLI_VERSION=1.16.238

RUN python3 -m pip install --upgrade pip \
    && pip3 install pipenv awscli==${AWSCLI_VERSION} \
    && echo "complete -C '$(which aws_completer)' aws" >> ~/.bashrc

# ========================================
# TERRAFORM
# ========================================

ENV TERRAFORM_VERSION=0.11.10

RUN curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && rm terraform.zip \
    && mv terraform /usr/local/bin/
    #&& terraform -install-autocomplete


# ========================================
# TERRAGRUNT
# ========================================

ENV TERRAGRUNT_VERSION=0.16.14

RUN curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o terragrunt \
    && chmod +x terragrunt \
    && mv terragrunt /usr/local/bin/

# ========================================
# AWS-IAM-AUTHENTICATOR
# ========================================

ENV AWSIAMAUTHENTICATOR_VERSION=1.14.6
ENV AWSIAMAUTHENTICATOR_BUILDDATE="2019-08-22"

RUN curl -L https://amazon-eks.s3-us-west-2.amazonaws.com/${AWSIAMAUTHENTICATOR_VERSION}/${AWSIAMAUTHENTICATOR_BUILDDATE}/bin/linux/amd64/aws-iam-authenticator -o ./aws-iam-authenticator \
    && chmod +x ./aws-iam-authenticator \
    && mv ./aws-iam-authenticator /usr/local/bin/

# ========================================
# SAML2AWS
# ========================================

ENV SAML2AWS_VERSION=2.20.0

RUN curl -L https://github.com/Versent/saml2aws/releases/download/v${SAML2AWS_VERSION}/saml2aws_${SAML2AWS_VERSION}_linux_amd64.tar.gz -o ./saml2aws.tar.gz \
    && tar xvzf ./saml2aws.tar.gz \
    && rm ./saml2aws.tar.gz \
    && chmod +x ./saml2aws \
    && mv ./saml2aws /usr/local/bin/

CMD [ "bash" ]