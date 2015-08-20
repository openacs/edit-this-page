
<property name="context">{/doc/edit-this-page {Edit This Page}} {Templates}</property>
<property name="doc(title)">Templates</property>
<master>

<body>
<h2>ETP Templates</h2><br clear="right"><a href="./">ETP Documentation</a>:ETP Templates

To use ETP, or in fact to effectively use OpenACS 4, it's essential
that you become familiar with the <a href="/doc/acs-templating/">OpenACS Templating System</a>. ETP's support
for rapid application development includes procedures for creating
the data sources that will be used by your page templates. You can
copy code from the examples in the
<code>packages/editthispage/templates</code> directory to get
started, but here's an overview of what you need to know.
<h3>Providing the "Edit this page" link</h3>
As demonstrated in
<code>packages/editthispage/www/master.tcl</code>, you should call
the procedure <b>etp::get_etp_link</b> from your own master
template, in order to determine whether or not to present the user
with the "Edit this page" option. The procedure returns the html
link only within an instance of the ETP package, and then only if
the user has write access. Otherwise an empty string is returned.
<h3>Retrieving page attributes for the template to display</h3>
Every ETP template will make use of the
<b>etp::get_page_attributes</b> procedure. It creates an array
variable called <code>pa</code> in the caller's stack frame,
containing all the attributes necessary to render the current page.
These attributes include the standard elements from the
cr_revisions table such as title, description, and content. If the
page is using a <a href="contenttypes">custom content type</a>, any
extended page attributes that correspond to it will be included.
<p>The complete list of standard attributes in the pa array is as
follows:</p><ul>
<li>item_id</li><li>name</li><li>revision_id</li><li>title</li><li>context_bar</li><li>description</li><li>publish_date</li><li>content</li><li><i>extended attributes, if any, defined by
etp::make_content_type</i></li>
</ul>
The procedure is designed to be efficient under heavy load. The
database is accessed once to retrieve the attributes, and a second
time to generate the page's context bar. The resulting array is
then cached in the server's memory until someone edits it.
<p>Once the <code>pa</code> array variable has been created as a
template data source, the template itself may reference the values
it contains using the standard syntax for "onerow" data sources;
for example, <code>\@pa.content\@</code>.</p><h3>Retrieving the list of pages in a content section</h3>
ETP templates used for the index page will almost always make use
of the <b>etp::get_content_items</b> procedure. It creates a
variable called <code>content_items</code> in the caller's stack
frame. This is a multirow result set suitable for passing to an
index template, containing all the structured data necessary to
present a list of links to content pages, folders, extlinks, or
symlinks. By making use of the procedure's switches you may modify
the query results it produces:
<ul>
<li><code>-attributes [list] - list of additional page attributes
to return (when required for display)</code></li><li><code>-orderby [list] - list of columns on which to
sort.</code></li><li><code>-where [list] - list of SQL where clauses to restrict the
query.</code></li>
</ul>
Each row in the result set always contains values for the following
page attributes:
<ul>
<li>name</li><li>url (use this to generate a link to this item)</li><li>title</li><li>description</li><li>object_type</li><li>publish_date</li><li>item_id</li>
</ul>
Additionally, you may name additional attributes that will be
returned, either from the standard page attributes stored in
cr_revisions, or extended page attributes defined with
etp::make_content_type.
<p>The content_items variable is created with a single db query,
and currently is never cached.</p><hr><table width="100%"><tbody><tr><td><address><a href="mailto:luke\@museatech.net">luke\@museatech.net</a></address></td></tr></tbody></table>
</body>
