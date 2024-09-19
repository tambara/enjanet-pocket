#!/bin/bash

# GitHub Secretを設定
gh secret set ENV_FILE < .env

KEY_JKS=$(base64 -w 0 android/app/key.jks)
echo $KEY_JKS | gh secret set KEY_JKS

KEY_PROPERTIES=$(base64 -w 0 android/key.properties)
echo $KEY_PROPERTIES | gh secret set KEY_PROPERTIES

