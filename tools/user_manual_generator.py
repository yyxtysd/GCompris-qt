#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# user_manual_generator.py
#
# Copyright (C) 2018 Johnny Jazeix <jzaeix@gmail.com>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, see <http://www.gnu.org/licenses/>.

from pylatex import Document, Section, Subsection, Tabularx, MultiColumn, \
 Figure, Package, NewLine, Command
from pylatex.utils import NoEscape

import sys
import os
import re
import polib

if len(sys.argv) != 2:
    print("Usage: user_manual_generator.py <locale>")
    sys.exit(1)
locale = sys.argv[1]

def getEnvVar(varName):
    if not os.environ.get(varName):
        print("Missing environment variable", varName)
        sys.exit(1)
    return os.environ[varName]

def getTranslatedText(original_text, po_file):
    text = [e.msgstr for e in po_file if original_text == e.msgid]
    return text[0] if text else original_text

#todo add all languages here
language_list= {'ca': 'catalan',
                'de': 'german',
                'en': 'english',
                'es': 'spanish',
                'fr': 'french',
                'nl': 'dutch',
                'uk': 'ukrainian'}

web_source = getEnvVar('GCOMPRIS_WEB_SRC')
gcompris_web_po = web_source + "/locale/" + locale + ".po"
gcompris_web_screenshots = web_source + "/screenshots_qt/middle/"

# todo check existence of po and screenshots files
gcompris_source = getEnvVar('GCOMPRIS_SRC')
gcompris_src_po = gcompris_source + "/po/gcompris_" + locale + ".po"
activity_dir = gcompris_source + "/src/activities/"
# todo check existence of po and activity files

filename = "userManual/userManual_" + locale

web_po_file = polib.pofile(gcompris_web_po, encoding="utf-8")
gcompris_po_file = polib.pofile(gcompris_src_po, encoding="utf-8")

web_po_translated_entries = web_po_file.translated_entries()
gcompris_po_translated_entries = gcompris_po_file.translated_entries()

doc = Document(document_options=language_list[locale])
doc.packages.append(Package('geometry', options=['tmargin=1cm',
                                                 'lmargin=1cm']))
doc.packages.append(Package('float'))
doc.packages.append(Package('babel', options=language_list[locale]))
doc.packages.append(Package('hyperref', options='hidelinks'))

doc.preamble.append(Command('title', 'GCompris user manual'))
doc.preamble.append(Command('author', 'GCompris developers\' team'))
doc.preamble.append(Command('date', NoEscape(r'\today')))
doc.append(NoEscape(r'\hypersetup{linktoc=all, citecolor=black, filecolor=black, linkcolor=black, urlcolor=black}'))
doc.append(NoEscape(r'\maketitle'))
doc.append(NoEscape(r'\tableofcontents'))
doc.append(NoEscape(r'\newpage'))

with doc.create(Section('Introduction', numbering=False)):
    doc.append('GCompris is a software...')

    for activity in os.listdir(activity_dir):
        if activity in ["CMakeLists.txt", "template", "createit.sh", "README", "activities.txt", "activities_out.txt", "activities.qrc", "menu"]:
            continue
        with open(activity_dir + "/" + activity + "/ActivityInfo.qml") as f:
            content = f.readlines()
            description = "need to fill a description for " + activity
            goal = "need to fill a goal for " + activity
            for line in content:
                m = re.match('.*title:.*\"(.*)\"', line)
                if m:
                    title = m.group(1)

                m = re.match('.*description:.*\"(.*)\"', line)
                if m and m.group(1):
                    description = m.group(1)

                m = re.match('.*goal:.*\"(.*)\"', line)
                if m:
                    goal = m.group(1)

        # todo get translation from po file
        translated_title = NoEscape(getTranslatedText(title, gcompris_po_translated_entries))
        with doc.create(Section(translated_title, numbering=False)):
            doc.append(NoEscape(r'\addcontentsline{toc}{section}{'+translated_title+'}'));
            doc.append(getTranslatedText(description, gcompris_po_translated_entries))
            doc.append(NewLine())
            doc.append(getTranslatedText("Goal:", gcompris_po_translated_entries) + " " + getTranslatedText(goal, gcompris_po_translated_entries))
            
            with doc.create(Figure(position='H')) as activity_picture:
                activity_image = gcompris_web_screenshots + activity + ".png"
                activity_picture.add_image(activity_image, width='250px')
                activity_picture.add_caption(translated_title)
            
            with doc.create(Tabularx("|l|l|", width_argument=NoEscape(r"\textwidth"))) as objective_tabular:
                objective_tabular.add_hline()
                objective_tabular.add_row([MultiColumn(2, align='l', data='Objectives')])
                objective_tabular.add_hline()
                objective_tabular.add_row([MultiColumn(2, align='l', data='first star & learn')])
                objective_tabular.add_hline()
                # todo fill content with dataset files objectives!
            
doc.generate_pdf(filename, clean_tex=False)

