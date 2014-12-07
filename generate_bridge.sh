
#!/bin/sh



PRODCT="${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}"
BRIDGE="${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/BridgeSupport"
DSTNTN="$BRIDGE/${PRODUCT_NAME}.bridgesupport"

echo "making dir ${BRIDGE}  for PATh:$PRODCT"

mkdir -p "${BRIDGE}"
gen_bridge_metadata -f "$PRODCT" -o "$BRIDGE/${PRODUCT_NAME}.bridgesupport"

# -o /YourFramework.framework/Resources/BridgeSupport/YourFramework.bridgesupport