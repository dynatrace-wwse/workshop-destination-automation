#!/bin/bash
#
# Interactive setup script for Workshop Destination Automation devcontainer
# Configures dtctl for Dynatrace and generates MCP configuration for Ansible Automation Platform
#

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "========================================="
echo " Workshop Destination Automation Setup  "
echo "========================================="
echo ""
echo "This script will configure:"
echo "  1. dtctl CLI for Dynatrace operations"
echo "  2. MCP configuration for Ansible Automation Platform"
echo ""

# Function to prompt for input with validation
prompt_input() {
    local prompt_message=$1
    local var_name=$2
    local allow_empty=${3:-false}
    local current_value=""
    
    while true; do
        read -p "${prompt_message}: " current_value
        
        if [ -z "$current_value" ] && [ "$allow_empty" = "false" ]; then
            echo -e "${RED}Error: This field cannot be empty${NC}"
            continue
        fi
        
        eval "$var_name='$current_value'"
        break
    done
}

# Function to check if dtctl context already exists
check_dtctl_context() {
    if dtctl config current-context 2>/dev/null | grep -q "workshop"; then
        return 0
    fi
    return 1
}

# Function to test dtctl connection
test_dtctl_connection() {
    echo -e "${BLUE}Testing dtctl connection...${NC}"
    if dtctl auth whoami --plain 2>/dev/null; then
        echo -e "${GREEN}✓ dtctl connection successful${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ dtctl connection test failed (you can configure this later)${NC}"
        return 1
    fi
}

###########################################
# Part 1: Dynatrace dtctl Configuration
###########################################

echo ""
echo "========================================="
echo " Part 1: Dynatrace Configuration       "
echo "========================================="
echo ""

if check_dtctl_context; then
    echo -e "${YELLOW}Existing dtctl context 'workshop' found.${NC}"
    read -p "Do you want to reconfigure it? (y/N): " reconfigure
    
    if [[ ! "$reconfigure" =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}Keeping existing dtctl configuration${NC}"
        SKIP_DTCTL=true
    else
        SKIP_DTCTL=false
    fi
else
    SKIP_DTCTL=false
fi

if [ "$SKIP_DTCTL" = "false" ]; then
    echo "Please provide your Dynatrace environment details:"
    echo ""
    
    prompt_input "Dynatrace Environment URL (e.g., https://abc12345.live.dynatrace.com)" DT_ENV_URL
    prompt_input "Dynatrace API Token" DT_API_TOKEN
    
    # Remove trailing slash from URL if present
    DT_ENV_URL=${DT_ENV_URL%/}
    
    echo ""
    echo -e "${BLUE}Configuring dtctl...${NC}"
    
    # Store credentials
    dtctl config set-credentials "workshop-token" --token "$DT_API_TOKEN"
    
    # Set context
    dtctl config set-context "workshop" \
        --environment "$DT_ENV_URL" \
        --token-ref "workshop-token"
    
    # Use the context
    dtctl config use-context "workshop"
    
    echo -e "${GREEN}✓ dtctl configured with context 'workshop'${NC}"
    
    # Test connection
    test_dtctl_connection || true
fi

###########################################
# Part 2: Ansible MCP Configuration
###########################################

echo ""
echo "========================================="
echo " Part 2: Ansible MCP Configuration     "
echo "========================================="
echo ""

MCP_JSON_PATH=".vscode/mcp.json"
MCP_BACKUP_PATH=".vscode/mcp.json.bak"
MCP_TEMPLATE_PATH=".devcontainer/mcp.json.template"

if [ -f "$MCP_JSON_PATH" ]; then
    echo -e "${YELLOW}Existing MCP configuration found at $MCP_JSON_PATH${NC}"
    read -p "Do you want to reconfigure it? (y/N): " reconfigure_mcp
    
    if [[ ! "$reconfigure_mcp" =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}Keeping existing MCP configuration${NC}"
        SKIP_MCP=true
    else
        SKIP_MCP=false
    fi
else
    SKIP_MCP=false
fi

if [ "$SKIP_MCP" = "false" ]; then
    echo "Please provide your Ansible Automation Platform (AAP) MCP server details:"
    echo ""
    echo "Note: The hostname should include the port if not using standard HTTPS (443)."
    echo "Example: ec2-3-230-212-158.compute-1.amazonaws.com:8448"
    echo ""
    
    prompt_input "AAP MCP Server Hostname (FQDN with port)" AAP_HOSTNAME
    prompt_input "AAP Bearer Token" AAP_TOKEN
    
    # Create .vscode directory if it doesn't exist
    mkdir -p .vscode
    
    # Backup existing mcp.json if it exists
    if [ -f "$MCP_JSON_PATH" ]; then
        echo -e "${BLUE}Creating backup at $MCP_BACKUP_PATH${NC}"
        cp "$MCP_JSON_PATH" "$MCP_BACKUP_PATH"
        echo -e "${GREEN}✓ Backup created${NC}"
    fi
    
    # Generate mcp.json from template
    echo -e "${BLUE}Generating MCP configuration from template...${NC}"
    
    if [ ! -f "$MCP_TEMPLATE_PATH" ]; then
        echo -e "${RED}Error: Template file not found at $MCP_TEMPLATE_PATH${NC}"
        exit 1
    fi
    
    # Use sed to replace placeholders
    sed -e "s|{{AAP_HOSTNAME}}|${AAP_HOSTNAME}|g" \
        -e "s|{{AAP_TOKEN}}|${AAP_TOKEN}|g" \
        "$MCP_TEMPLATE_PATH" > "$MCP_JSON_PATH"
    
    echo -e "${GREEN}✓ MCP configuration generated at $MCP_JSON_PATH${NC}"
    
    # Validate JSON
    if jq empty "$MCP_JSON_PATH" 2>/dev/null; then
        echo -e "${GREEN}✓ JSON validation passed${NC}"
    else
        echo -e "${RED}✗ JSON validation failed${NC}"
        echo "Please check the generated file at $MCP_JSON_PATH"
        exit 1
    fi
    
    # Show configured servers
    echo ""
    echo -e "${BLUE}Configured MCP servers:${NC}"
    jq -r '.servers | keys[]' "$MCP_JSON_PATH" | sed 's/^/  - /'
fi

###########################################
# Summary
###########################################

echo ""
echo "========================================="
echo " Configuration Complete!                "
echo "========================================="
echo ""

if [ "$SKIP_DTCTL" = "false" ]; then
    echo -e "${GREEN}✓${NC} Dynatrace dtctl configured"
    echo "  Context: $(dtctl config current-context)"
    echo "  Environment: $DT_ENV_URL"
fi

if [ "$SKIP_MCP" = "false" ]; then
    echo -e "${GREEN}✓${NC} Ansible MCP configuration generated"
    echo "  File: $MCP_JSON_PATH"
    echo "  Hostname: $AAP_HOSTNAME"
    echo "  Servers: 6 MCP endpoints configured"
fi

echo ""
echo "You can now use GitHub Copilot to:"
echo "  - Query Dynatrace using dtctl skill"
echo "  - Interact with Ansible Automation Platform via MCP"
echo ""
echo "To reconfigure at any time, run:"
echo "  .devcontainer/setup.sh"
echo ""
echo "========================================="
