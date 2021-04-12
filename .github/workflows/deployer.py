#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys

from telegram import Bot

mode = sys.argv[1]
token = os.environ["BOT_TOKEN"]
dev_chat_id = os.environ["DEV_CHAT_ID"]
owner_username = "@HKyouma"
project_name = "corpse_tools"

bot = Bot(token)

def check_analyze():
    critical_issues_count = 0
    issues_count = 0

    for line in sys.stdin.readlines():
        info = line.strip().split("|")
        issue_type = info[1]

        if issue_type not in ["LINT", "HINT"]:
            critical_issues_count += 1

        issues_count += 1

    if critical_issues_count > 0:
        analyze_failed(issues_count, critical_issues_count)
        exit(1)

    analyze_success(issues_count)


def broadcast_message(message):
    bot.send_message(dev_chat_id, message, parse_mode="markdown")


def analyze_failed(issues_count: int, critical_issues_count: int):
    broadcast_message(f"{owner_username}, last *{project_name}* analyze check found {issues_count} issues, "
                      f"*{critical_issues_count}* of them being critical.\n"
                      f"Please fix them!")


def analyze_success(issues_count: int):
    if issues_count > 0:
        broadcast_message(f"{owner_username}, last *{project_name}* analyze found *{issues_count}* issues, "
                          f"but none of them were critical!")
    else:
        broadcast_message(f"{owner_username}, last *{project_name}* analyze found no issues!")


def main():
    if mode == "check_analyze":
        return check_analyze()


if __name__ == "__main__":
    main()