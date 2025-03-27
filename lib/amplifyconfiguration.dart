const amplifyconfig = '''
{
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify/cli",
        "Version": "0.1.0",
        "IdentityManager": {
          "Default": {}
        },
        "CredentialsProvider": {
          "CognitoIdentity": {
            "Default": {
              "PoolId": "eu-central-1:cb67c36b-b437-4f67-ac92-55e64bbf7385",
              "Region": "eu-central-1"
            }
          }
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "eu-central-1_kTprY3k4u",
            "AppClientId": "59ds4o3rvaa2bp2rshi4dqc586",
            "Region": "eu-central-1"
          }
        }
      }
    }
  },
  "storage": {
    "plugins": {
      "awsS3StoragePlugin": {
        "bucket": "autopark",
        "region": "eu-central-1"
      }
    }
  }
}
'''; 