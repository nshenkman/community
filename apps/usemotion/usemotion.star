"""
Applet: Fi
Summary: Pet activity tracker
Description: Connects to Fi APIs to get latest daily data of your pet.
Author: nshenkman
"""
load("cache.star", "cache")
load("encoding/json.star", "json")
load("humanize.star", "humanize")
load("http.star", "http")
load("time.star", "time")
load("schema.star", "schema")
load("secret.star", "secret")
load("render.star", "render")
load("animation.star", "animation")
load("encoding/base64.star", "base64")
load("math.star", "math")


HOUSE_LABEL_COLOR = "#4CAF50"
BUY_LABEL_COLOR = "#2196F3"
CHORE_LABEL_COLOR = '#9C27B0'
WEDDING_LABEL_COLOR = '#FFEB3B'
ENTERTAINMENT_LABEL_COLOR = '#FF9800'

LABEL_COLOR_MAP = {
    "Chore": CHORE_LABEL_COLOR,
    "Buy": BUY_LABEL_COLOR,
    "House": HOUSE_LABEL_COLOR,
    "Wedding": WEDDING_LABEL_COLOR,
    "Entertainment": ENTERTAINMENT_LABEL_COLOR,
}


def main(config):
    apiKey = humanize.url_decode(config.get("apiKey"))

    print("api key length", len(apiKey))
    res = http.get("https://api.usemotion.com/v1/tasks", headers={
        "X-API-Key": apiKey
    })

    tasks = res.json()["tasks"]
    next_due_task = None

    for task in tasks:
        if task["scheduledStart"]:
            task_due_date = time.parse_time(task["scheduledStart"])

            if not task["completed"] and next_due_task == None or task_due_date < time.parse_time(next_due_task["scheduledStart"]):
                next_due_task = task

    if next_due_task != None:
        due_date_time = time.parse_time(next_due_task["dueDate"])
        scheduled_time = time.parse_time(next_due_task["scheduledStart"], location="America/Los_Angeles")
        title = render.Text(content=next_due_task["name"])
        labels = [
            render.Padding(
                child=render.Text(content=label["name"], color="#000"),
                color=LABEL_COLOR_MAP.get(label["name"], "#000"),
                pad=1,
            ) for label in next_due_task["labels"]
        ]

        now = time.now().in_location("America/Los_Angeles")
        tomorrow = now + time.parse_duration("24h")


        scheduled_text = scheduled_time.in_location("America/Los_Angeles").format("01/02")
        is_today = now.format("01/02") == scheduled_text
        is_tomorrow = scheduled_text == tomorrow.format("01/02")

        if is_today:
            scheduled_text = "Today"
        elif is_tomorrow:
            scheduled_text = "Tmrw"

        scheduled_text = scheduled_text + " " + scheduled_time.in_location("America/Los_Angeles").format("3:04 PM")
        scheduled_date = render.Text(
            content=scheduled_text,
            color="#FFA726" if due_date_time < time.now().in_location("America/Los_Angeles") else "#A5D6A7",
        )
    else:
        return render.Root(
            render.Row(
                cross_align="center",
                main_align="center",
                children=[
                    render.WrappedText(content="All Tasks Completed!", align="center"),
                ],
                expanded=True,
            ),
        )

    return render.Root(
        child=render.Column(
            children= [
                render.Row(
                    cross_align="center",
                    main_align="center",
                    children=[
                        render.Marquee(width=64, child=title, align="center")
                    ],
                    expanded=True,

                ),
                render.Row(
                    cross_align="center",
                    main_align="center",
                    children=[
                        scheduled_date,
                    ],
                    expanded=True,

                ),
                render.Row(
                    cross_align="center",
                    main_align="space_evenly",
                    children=labels,
                    expanded=True,
                ),
            ]
        )
    )


def get_schema():
    return schema.Schema(
        version="1",
        fields=[
            schema.Text(
                id="apiKey",
                name="Api Key",
                desc="API Key for useMotion",
                icon="gear",
            ),
        ],
    )