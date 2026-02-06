---
name: answer-user-questions-about-code
description: Answer questions about code without making changes to it. Use when the user asks how something works, where something is located, or wants to understand code behavior without requesting that any action be taken.
argument-hint: [question about the code]
---

# Answer Questions About Code

Precisely follow the following workflow to answer the user's question: $ARGUMENTS

## Step 1: Discover the Answer

Use the `explore-and-discover` skill to discover an answer to the user's question in the format required by the next step

### Step 2: Provide an Answer

Summary: <short summary of the answer>
Details: <more detailed answer, following the answer detail guidelines below>
(if applicable) Assumptions Made: <list of any ambiguities in the user's request, and the assumptions made in this response>
(if applicable) Suggested Next Steps: <list of suggested follow-up questions that may be useful for the user to ask>

#### Answer Detail Guidelines

- Reference specific file paths and line numbers when citing code
- If the answer requires understanding multiple files, explain the relationships
- If you're uncertain about something, say so rather than guessing
- Keep the answer focused on what was asked

### Step 3: Iterate

If the user has further questions, return to step 1 and continue from there, making use of the context you have already gathered to search more efficiently and answer more effectively

## General Guidelines

- Do not modify any files unless asked to do so
