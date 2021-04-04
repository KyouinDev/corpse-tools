#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys

from telegram import Bot

mode = sys.argv[1]
token = os.environ["BOT_TOKEN"]
dev_chat_id = os.environ["DEV_CHAT_ID"]
owner_username = "@HKyouma"

bot = Bot(token)

def check_analyze():
    critical_issues_count = 0
    issues_count = 0

    for line in sys.stdin.readlines():
        info = line.strip().split("|")
        issue_type = info[1]

        if issue_type != "LINT":
            critical_issues_count += 1

        issues_count += 1

    if issues_count > 0:
        analyze_failed(issues_count, critical_issues_count)
        exit(1)

    analyze_success()
    exit(0)


def broadcast_message(message):
    bot.send_message(dev_chat_id, message, parse_mode="markdown")


def analyze_failed(issues_count: int, critical_issues_count: int):
    broadcast_message(f"{owner_username}, last analyze check found some critical issues:\n\n"
                      f"*{critical_issues_count}* critical issues\n"
                      f"*{issues_count}* total issues\n\n"
                      f"Please fix them!")


def analyze_success():
    broadcast_message(f"{owner_username}, last analyze check found no critical issues.\n"
                      f"It seems alright!")


def main():
    if mode == "check_analyze":
        return check_analyze()


if __name__ == "__main__":
    main()