#!/bin/bash

PROTO_DIR=./protos
OUT_DIR=./src/grpc/generated

# Create output directory if it doesn't exist
mkdir -p $OUT_DIR

# Check if ts-proto is installed
if ! command -v npx ts-proto &> /dev/null; then
    echo "Installing ts-proto..."
    npm install -D ts-proto
fi

# Generate TypeScript code from proto files
echo "Generating TypeScript from proto files..."
npx ts-proto \
  --proto_path=$PROTO_DIR \
  --ts_proto_out=$OUT_DIR \
  --ts_proto_opt=nestJs=true \
  --ts_proto_opt=addGrpcMetadata=true \
  --ts_proto_opt=addNestjsRestParameter=true \
  $PROTO_DIR/*.proto

echo "Proto files generated successfully!"
