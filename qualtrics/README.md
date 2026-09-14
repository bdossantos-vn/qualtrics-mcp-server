# Qualtrics for Claude

Connects Claude to Qualtrics so you can ask, in plain English, for things like:

- "List my Qualtrics surveys"
- "Show me how the screener in the Conair Hair Tools survey is built"
- "Export the responses from that survey"
- "What are the current quotas on this study and how full are they?"

## Setup

You need two things: Claude desktop app, and your Qualtrics API token (Brianna
will send you yours).

1. In Claude, click the **+** button next to the message box.
2. Choose **Plugins**, then **Add plugin**.
3. Add the marketplace: `bdossantos-vn/qualtrics-mcp-server`
4. Install the **Qualtrics** plugin.
5. When it asks for your **Qualtrics API token**, paste the one Brianna sent you.
   Leave the datacenter as `yul1` and read-only as `true`.
6. Turn on **auto-update** for the Viral Nation marketplace so you get future
   improvements without doing anything.
7. Quit Claude completely and reopen it.

## Check that it worked

Start a new chat and type:

```
List my Qualtrics surveys
```

If Claude comes back with your actual surveys, you are done.

## Read-only mode

Out of the box this is read-only. Claude can look at and export your Qualtrics
data, but it cannot create, change or delete anything. This is deliberate. Ask
Brianna if you need write access for a specific piece of work.

## Your token is yours

Everyone uses their own personal Qualtrics token. Don't paste yours into chats,
emails or shared docs, and don't share it with anyone else.

## If something goes wrong

Tell Brianna what you typed and what Claude said back. Don't spend time
troubleshooting it yourself.
