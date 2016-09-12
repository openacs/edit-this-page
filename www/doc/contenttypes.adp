
<property name="context">{/doc/edit-this-page {Edit This Page}} {Content Types}</property>
<property name="doc(title)">Content Types</property>
<master>
<h2>ETP Content Types</h2>
<br clear="right">
<a href="./">ETP Documentation</a>
:ETP Content Types
<h3>Standard page attributes</h3>

The content repository data model (a standard part of OpenACS 4)
primarily keeps track of <em>content items</em>
, each of which may
have multiple <em>content revisions</em>
. The
<code>content_revision</code>
 object type refers to a row in the
<code>cr_revisions</code>
 table. Each revision contains the
standard attributes of the pages you create with ETP, such as
Title, Description, and Content. Additionally, the standard
<code>acs_object</code>
 attributes are stored for each revision,
such as the creation date and creating user.
<p>Referring back to the definition of the default ETP application,
you&#39;ll notice that it specifies that the
<code>etp_page_revision</code> content type is to be used for the
index page and for all content pages. etp_page_revision is a
subtype of content_revision, but does not add any additional
attributes. It is just for easier integration with the search
package. The page templates used by the default application may
refer to only the standard page attributes stored in the
<code>cr_revisions</code> table.</p>
<h3>Extended page attributes: why do we need them?</h3>

The standard page attributes, while providing all the basic
functionality for a collaboratively edited website, are rarely
sufficient to implement real world designs.
<p>Imagine you&#39;re creating an online scientific journal. The
graphic design mockup shows you that each issue of the journal
contains a table of contents listing all the articles in that
issue. However, the table of contents is organized into multiple
sections: Editorial, Research, Corrections, and so on. You also
notice that the design assumes that each journal issue has a
distinguishable publication date, and that each journal article has
a distinguishable abstract (a quick summary of the writers'
findings which can be skimmed or searched).</p>
<p>All the standard page attributes (Title, Description, Content,
etc.) are still useful, but in order to provide the structured data
elements implied by the journal templates, we need to define some
extended page attributes. In particular, we know that journal
issues need to have a publication date, and journal articles need
to have a section and an abstract.</p>
<h3>Defining a new content type</h3>

Creating a new content type is done by calling the
<code>
<strong style="color: black; background-color: rgb(255, 255, 102);">etp</strong>::define_content_type</code>

procedure from one of your tcl library files. Here&#39;s how you
would accomplish the journal example discussed above:
<blockquote><pre>
etp::define_content_type journal_issue "Journal Issue" "Journal Issues" {
    { publication_date "Publication Date" "Publication Dates" string "size=60" "" }
}

etp::define_content_type journal_article "Journal Article" "Journal Articles" {
    { section Section Sections string "" "" }
    { abstract Abstract Abstracts string "rows=24 cols=80" "" }
}
</pre></blockquote>

The first 3 parameters to <code>define_content_type</code>
 are the
internal name of the content type, the name to display, and the
plural form of that name. The fourth parameter is a list of records
describing each extended page attribute. Each record is a list
containing the following values (in sequence):
<ul>
<li>attribute_name</li><li>pretty_name</li><li>pretty_plural</li><li>datatype (must be one of the entries in acs_datatypes: string,
boolean, number, integer, date, etc.)</li><li>html (a string containing html attributes for the input
control. useful attributes are "size=X" to specify the
size of standard input controls, and "rows=X cols=X" to
specify the size of a textarea. Textareas will be used only if the
datatype is string and html specifies rows or cols.)</li><li>default_value (can either be a string denoting a single default
value, or the name of a callback function you&#39;ve defined in the
etp namespace which is used to provide values for select
lists).</li>
</ul>

Once you&#39;ve defined a content type, you may refer to it when
calling the <code>etp::define_application</code>
 procedure to set
up a new application. To continue with our journal example,
you&#39;d want to do this as follows:
<blockquote><pre>
etp::define_application journal {
    index_template                www/templates/journal-issue
    index_object_name             "Journal Issue"
    index_content_type            journal_issue

    content_template              www/templates/journal-article
    content_object_name           "Article"
    content_content_type          journal_article
}
</pre></blockquote>

Creating the templates that make use of your custom content types
is the subject of the <a href="templates">next page</a>
. After
that&#39;s been done, the authors of the journal will be able to
create a new issue of the journal simply by creating a new instance
of the ETP package (a process that&#39;s automated within the ETP
interface by the "create subtopic" command) and ensuring
that the new content section is using the journal application. This
setup can be automated, since it&#39;s possible to specify the
application to use for any subtopic created within a particular
directory.
<hr>
<table width="100%"><tbody><tr><td><address><a href="mailto:luke\@museatech.net">luke\@museatech.net</a></address></td></tr></tbody></table>
