package testimpl

import (
	"os"
	"testing"
	"context"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/to"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	// "github.com/Azure/azure-sdk-for-go/sdk/data/azappconfig"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/appconfiguration/armappconfiguration/v2"
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

	t.Run("TestAppConfiguration", func(t *testing.T) {
		// resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
		appconfigName := terraform.Output(t, ctx.TerratestTerraformOptions(), "app_configuration_name")

		resp, err := clientFactory.NewOperationsClient().CheckNameAvailability(context.Background(), armappconfiguration.CheckNameAvailabilityParameters{
			Name: to.Ptr(appconfigName),
			Type: to.Ptr(armappconfiguration.ConfigurationResourceTypeMicrosoftAppConfigurationConfigurationStores),
		}, nil)
		if err != nil {
			t.Fatalf("failed to finish the request: %v", err)
		}

		assert.True(t, *resp.NameAvailable)
	})

	// TODO
	// t.Run("TestKeyValues", func(t *testing.T) {
	// }
}
