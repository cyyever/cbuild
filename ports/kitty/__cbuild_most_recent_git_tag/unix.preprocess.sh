${sed_cmd} -i -e '/copy_man_pages(ddir)/d' setup.py
${sed_cmd} -i -e '/copy_html_docs(ddir)/d' setup.py
# ${sed_cmd} -i -e "/if not os.path.exists('docs/d" setup.py
${sed_cmd} -i -e "/run_tool(.'make', 'docs'.)/d" setup.py
