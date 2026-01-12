import QtQuick

/**
 * An AI model representation.
 * - name: Friendly name of the model
 * - icon: Icon name of the model
 * - description: Description of the model
 * - endpoint: API endpoint URL
 * - model: Model code (like gpt-4 or llama3.2)
 * - requires_key: Whether the model requires an API key
 * - key_id: The identifier of the API key in keyring
 * - key_get_link: Link to get an API key
 * - key_get_description: Description of how to get an API key
 * - api_format: The API format (always "openai" for our implementation)
 * - extraParams: Extra parameters to be passed to the model
 */
QtObject {
    property string name
    property string icon
    property string description
    property string homepage
    property string endpoint
    property string model
    property bool requires_key: true
    property string key_id
    property string key_get_link
    property string key_get_description
    property string api_format: "openai"
    property var extraParams: ({})
}
