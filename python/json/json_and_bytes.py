import json
import subprocess


def get_latest_issue_title():
    cmd = DOCKER_CMD + ["gh", "issue", "list"] + REPO_SWITCH + ["--limit", "1", "--state", "all", "--json", "number,createdAt,title", "--jq", '.[0]']
    ret = subprocess.run(cmd, capture_output=True)

    # Decode the string!!!! this will make it not rubbish to parse
    stdout = ret.stdout.decode('utf-8')
    print(stdout)
    print(str(ret))

    # JSON `LOADS` is the one. However it accepts bytes so the previosu decode is worthless
    foo = json.loads(stdout)
    print(foo["title"])
    return foo["title"]