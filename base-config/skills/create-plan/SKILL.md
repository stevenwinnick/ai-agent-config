---
name: create-plan
description: Generate a detailed implementation plan for review before coding. Use when approaching a complex task where the best approach is not immediately clear.
---

# Generate Implementation Plan

Create a detailed implementation plan for: $ARGUMENTS

## Step 1: Identify Plan Constraints

Identify any constraints on the plan possibility space. This may include constraints to iterate on a previous plan, rather than generating an entirely new one.

## Step 2: Identify Plan Details

Use the `explore-and-discover` skill to identify the plan details in the format required by the next step

## Step 3: Present Plan

Present a plan in the format from `plan-template.md`

## Step 4: Iterate

If the user asks questions about the plan, answer them without updating the plan. If the user instructs you to update the plan, return to step 1 and continue from there.
