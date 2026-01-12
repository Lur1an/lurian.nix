import QtQuick

/**
 * Represents a message in an AI conversation.
 * Follows the OpenAI API message structure.
 */
QtObject {
    property string role           // "user", "assistant", "system", "interface"
    property string content        // Rendered content
    property string rawContent     // Raw content for API
    property string model          // Model that generated this
    property bool thinking: true   // Show loading indicator
    property bool done: false      // Response complete
    property var annotations: []   // Citations/links
    property string functionName   // For function calls
    property var functionCall      // Function call details
    property string functionResponse
    property bool functionPending: false  // Awaiting user approval
    property bool visibleToUser: true
}
