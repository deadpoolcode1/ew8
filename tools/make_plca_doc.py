#!/usr/bin/env python3
"""Generate docs/Configuring-Lane-Change-Alert.docx — a plain-language guide
for enabling/adjusting the PLCA lane-change alert by configuration only."""
from docx import Document
from docx.shared import Pt, RGBColor
from docx.oxml.ns import qn

doc = Document()

# --- base style tweaks ---
normal = doc.styles["Normal"]
normal.font.name = "Calibri"
normal.font.size = Pt(11)


def code(text):
    """Add a monospace, lightly shaded code line."""
    p = doc.add_paragraph()
    run = p.add_run(text)
    run.font.name = "Consolas"
    run.font.size = Pt(9.5)
    # set monospace for east-asian fallback too
    rpr = run._element.get_or_add_rPr()
    rfonts = rpr.get_or_add_rFonts()
    rfonts.set(qn("w:ascii"), "Consolas")
    rfonts.set(qn("w:hAnsi"), "Consolas")
    p.paragraph_format.space_after = Pt(2)
    p.paragraph_format.space_before = Pt(2)
    return p


def para(text, style=None):
    return doc.add_paragraph(text, style=style)


def h1(text):
    return doc.add_heading(text, level=1)


# ------------------------------------------------------------------ title
t = doc.add_heading("Configuring the Lane-Change Alert (PLCA)", level=0)
para("How to turn on and adjust the lane-change alert without rebuilding the app")

para(
    "The EW8 display lets you add a brand-new alert by editing plain configuration "
    "files and dropping a few files next to the application – no programming and no "
    "rebuilding. The program file (nquick) stays exactly the same before and after. "
    "This guide uses the lane-change alert (also called PLCA) as a worked example, "
    "but the same four steps add any new signal-driven alert."
)

# ------------------------------------------------------------------ what you get
h1("What this feature does")
para(
    "The lane-change alert shows a coloured bar on the left or right edge of the "
    "screen when another vehicle is in your blind spot on that side:"
)
para("A yellow bar means “information” – a vehicle is there.", style="List Bullet")
para("A red bar means “warning” – don’t change lanes now.", style="List Bullet")
para(
    "The left and right sides are independent, so you can see, for example, a red "
    "bar on the left and a yellow bar on the right at the same time. If both yellow "
    "and red are sent for the same side, red is shown (it is the stronger warning)."
)

# ------------------------------------------------------------------ big idea
h1("The idea: a new alert by configuration only")
para(
    "The display is driven by a set of text files and images that sit next to the "
    "application. To add an alert you change four things – no source code is touched:"
)
para("A bus description file (.dbc) – tells the app how to read the alert message coming in over the vehicle bus.", style="List Number")
para("The signals file – gives each indicator a name and connects the bus message to it.", style="List Number")
para("One or more images – the picture(s) the alert shows.", style="List Number")
para("The scene file – says where on the screen the alert appears.", style="List Number")
para(
    "When the app starts, it reads these files and creates the alert for you. A new "
    "name in the signals file becomes a brand-new alert automatically – nothing is "
    "fixed in the program in advance."
)

# ------------------------------------------------------------------ scope
h1("What kinds of alerts you can add this way")
para(
    "Anything that is “a signal from the bus turns a picture (or a number) on the "
    "screen” can be added with configuration only. That includes:"
)
para("An icon or bar that simply appears and disappears (like the lane-change bars).", style="List Bullet")
para("An icon that blinks.", style="List Bullet")
para("An icon that shows for a few seconds and then hides by itself (a timed sign).", style="List Bullet")
para("A number shown on the screen (for example a distance or a speed).", style="List Bullet")
para("A small animation (an animated image / GIF).", style="List Bullet")
para(
    "What is not configuration-only: an alert that needs brand-new on-screen "
    "behaviour that none of the above can do (special moving graphics or "
    "decision logic of its own). That kind of alert needs a developer. For everyday "
    "“show this when the bus says so” alerts, configuration is all you need."
)

# ------------------------------------------------------------------ apply
h1("How to apply your changes (how it takes effect)")
para(
    "All of these files live in the application folder. You edit them with any text "
    "editor (Notepad, VS Code, etc.) – they are plain text – and copy the images "
    "and the .dbc into their folders. Then:"
)
para("Make your edits / copy your files in (see the steps below).", style="List Number")
para("Save.", style="List Number")
para("Restart the application.", style="List Number")
para(
    "That’s it. The change appears the next time the app starts. The app reads "
    "these files fresh on every start-up, so there is nothing to compile and no "
    "developer needed. The same program file is used before and after – only the "
    "configuration around it changed."
)

# ------------------------------------------------------------------ folders
h1("Where the files live")
para("Next to the application you will find these folders:")
code("DBC/        → bus description files (.dbc)")
code("signals/    → EW8_Signals.json")
code("configs/    → scene.json")
code("assets/     → images")
para(
    "The app finds a .dbc automatically by its name, so simply putting the file in "
    "the DBC folder is enough – no list to update."
)

# ------------------------------------------------------------------ step 1 dbc
h1("Step 1 – The bus description file (.dbc)")
para(
    "This file tells the app which message on the bus carries the alert and which "
    "bit means what. Create a file in the DBC folder named after the protocol, for "
    "example:"
)
code("DBC/JunctionBox_Protocol_led257.dbc")
para("Inside, the important part describes one message and four on/off bits:")
code("BO_ 768 JunctionBox_LCA: 8 Vector__XXX")
code(" SG_ LCA_Left_Info  : 0|1@1+ (1,0) [0|1] \"\" Vector__XXX")
code(" SG_ LCA_Right_Info : 1|1@1+ (1,0) [0|1] \"\" Vector__XXX")
code(" SG_ LCA_Left_Warn  : 2|1@1+ (1,0) [0|1] \"\" Vector__XXX")
code(" SG_ LCA_Right_Warn : 3|1@1+ (1,0) [0|1] \"\" Vector__XXX")
para("In plain words:")
para("768 is the message number (the same as 0x300).", style="List Bullet")
para("Each SG_ line is one on/off flag: left/right, info (yellow) or warn (red).", style="List Bullet")
para(
    "Important: the message number and the bit positions must match what your "
    "vehicle / test equipment actually sends. Use the numbers from your real "
    "lane-change device; the values above are an example.",
    style="List Bullet",
)

# ------------------------------------------------------------------ step 2 signals
h1("Step 2 – Name the indicators and link them")
para("Open:")
code("signals/EW8_Signals.json")
para(
    "First, add four names so the display knows these indicators exist (put them "
    "near the other ALERT_ names at the top of the file):"
)
code("\"ALERT_LEFT_LCAI\"")
code("\"ALERT_RIGHT_LCAI\"")
code("\"ALERT_LEFT_LCAW\"")
code("\"ALERT_RIGHT_LCAW\"")
para("(LCAI = info/yellow, LCAW = warn/red.)")
para(
    "Then, lower down, add a block that connects each bus flag from Step 1 to the "
    "matching indicator name:"
)
code("{")
code("    \"protocol\": \"JunctionBox_Protocol_led257\",")
code("    \"signals\": [")
code("        {\"name\": \"LCA_Left_Info\",  \"action\": \"ALERT_LEFT_LCAI\",  \"type\": \"GraphicItem\"}")
code("       ,{\"name\": \"LCA_Right_Info\", \"action\": \"ALERT_RIGHT_LCAI\", \"type\": \"GraphicItem\"}")
code("       ,{\"name\": \"LCA_Left_Warn\",  \"action\": \"ALERT_LEFT_LCAW\",  \"type\": \"GraphicItem\"}")
code("       ,{\"name\": \"LCA_Right_Warn\", \"action\": \"ALERT_RIGHT_LCAW\", \"type\": \"GraphicItem\"}")
code("    ]")
code("}")
para(
    "The “protocol” name must match the .dbc file name from Step 1. “name” is the "
    "bus flag; “action” is the indicator it turns on."
)

# ------------------------------------------------------------------ step 3 images
h1("Step 3 – The images")
para("Put the two bar pictures here:")
code("assets/images/LCA/LCA_Yellow.png   (the info bar)")
code("assets/images/LCA/LCA_Red.png      (the warning bar)")
para(
    "You can replace these with your own artwork at any time – just keep the same "
    "file names, or update the names in Step 4 to match."
)

# ------------------------------------------------------------------ step 4 scene
h1("Step 4 – Where the bars appear on screen")
para("Open:")
code("configs/scene.json")
para("Add this block inside the “nodes” list:")
code("{")
code("  \"parent\": \"mainPanel\",")
code("  \"type\": \"group\",")
code("  \"id\": \"lcaPanel\",")
code("  \"layer\": 1,")
code("  \"children\": [")
code("    { \"type\": \"image\", \"graphic_item\": \"ALERT_LEFT_LCAI\",  \"src\": \"A:images/LCA/LCA_Yellow.png\", \"align\": \"left_mid\",  \"offset\": [2, 0],  \"layer\": 0 },")
code("    { \"type\": \"image\", \"graphic_item\": \"ALERT_RIGHT_LCAI\", \"src\": \"A:images/LCA/LCA_Yellow.png\", \"align\": \"right_mid\", \"offset\": [-2, 0], \"layer\": 0 },")
code("    { \"type\": \"image\", \"graphic_item\": \"ALERT_LEFT_LCAW\",  \"src\": \"A:images/LCA/LCA_Red.png\",    \"align\": \"left_mid\",  \"offset\": [2, 0],  \"layer\": 0 },")
code("    { \"type\": \"image\", \"graphic_item\": \"ALERT_RIGHT_LCAW\", \"src\": \"A:images/LCA/LCA_Red.png\",    \"align\": \"right_mid\", \"offset\": [-2, 0], \"layer\": 0 }")
code("  ]")
code("}")
para("What the values mean:")
para("graphic_item – the indicator name from Step 2 (this links the picture to the bus flag).", style="List Bullet")
para("src – which picture to show. “A:” means the assets folder.", style="List Bullet")
para("align – left_mid puts it on the left edge, right_mid on the right edge.", style="List Bullet")
para("offset – a small nudge in pixels [left-right, up-down] to fine-tune the position.", style="List Bullet")
para(
    "Tip: list the red (warn) bars after the yellow (info) bars, as shown. That way, "
    "if both arrive for the same side, the red one is drawn on top."
)

# ------------------------------------------------------------------ test
h1("How to check it works")
para(
    "Restart the app, then have your bus tool send the message (number 768 / 0x300) "
    "with different bytes. The first byte controls the bars:"
)
code("300#06  →  left red + right yellow")
code("300#0C  →  both sides red")
code("300#00  →  all bars off")
para(
    "If nothing appears, re-check that the message number and bits in the .dbc match "
    "what your tool is sending, and that the four names match exactly in all files."
)

# ------------------------------------------------------------------ quick adjust
h1("Common adjustments")
para("Move a bar inward/outward: change the first number in offset (left-right).", style="List Bullet")
para("Move a bar up/down: change the second number in offset.", style="List Bullet")
para("Use different artwork: replace the PNG files, or point src at a different file name.", style="List Bullet")
para("Change which bus message/bits are used: edit the .dbc in Step 1.", style="List Bullet")

para("")
para(
    "Remember: after any change, just save and restart the app. No rebuild is ever "
    "required for these adjustments."
)

out = "docs/Configuring-Lane-Change-Alert.docx"
doc.save(out)
print("wrote", out)
