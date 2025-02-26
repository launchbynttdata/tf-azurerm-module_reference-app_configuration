package testimpl

import (
	"context"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"

	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/appconfiguration/armappconfiguration/v2"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestAppConfiguration(t *testing.T, ctx types.TestContext) {
	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")

	if len(subscriptionId) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Unable to get credentials: %e\n", err)
	}

	options := arm.ClientOptions{
		ClientOptions: azcore.ClientOptions{
			Cloud: cloud.AzurePublic,
		},
	}

	clientFactory, err := armappconfiguration.NewClientFactory(subscriptionId, cred, &options)
	if err != nil {
		t.Fatalf("failed to create client: %v", err)
	}

	appconfigName := terraform.Output(t, ctx.TerratestTerraformOptions(), "app_configuration_name")
	resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")

	t.Run("TestAppConfiguration", func(t *testing.T) {
		resp, err := clientFactory.NewConfigurationStoresClient().Get(context.Background(), resourceGroupName, appconfigName, nil)
		if err != nil {
			t.Fatalf("failed to finish the request: %v", err)
		}

		assert.Equal(t, appconfigName, *resp.Name)
	})

	t.Run("TestAppConfigurationDataKeys", func(t *testing.T) {
		keyValue, err := clientFactory.NewKeyValuesClient().Get(context.Background(), resourceGroupName, appconfigName, "test-config-key", nil)
		if err != nil {
			t.Fatalf("failed to finish the request: %v", err)
		}
		assert.Equal(t, "Hello, World!", keyValue)
	})

}
