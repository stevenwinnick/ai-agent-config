---
name: answering-code-questions
description: Answers questions about code without making changes. Use when the user asks how something works, where something is located, or wants to understand code behavior without requesting modifications.
argument-hint: [question about the code]
---

# Answer Questions About Code

Follow this workflow to answer the user's question: $ARGUMENTS

## Step 1: Discover the Answer

Use the `exploring-and-discovering` skill to find the answer in the format required by the next step.

## Step 2: Provide an Answer

Summary: <short summary of the answer>
Details: <more detailed answer>
(if applicable) Assumptions Made: <list of any ambiguities in the user's request, and the assumptions made in this response>
(if applicable) Suggested Next Steps: <list of suggested follow-up questions that may be useful>

### Answer Detail Guidelines

- Reference specific file paths and line numbers when citing code
- If the answer requires understanding multiple files, explain the relationships
- If you're uncertain about something, say so rather than guessing

## Step 3: Iterate

If the user has further questions, return to step 1, making use of context already gathered.

## General Guidelines

- Do not modify any files unless asked to do so
