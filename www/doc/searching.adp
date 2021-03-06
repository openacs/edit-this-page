
<property name="context">{/doc/edit-this-page {Edit This Page}} {Searching Edit This Page}</property>
<property name="doc(title)">Searching Edit This Page</property>
<master>
<h2>Searching Edit This Page (Postgresql/OpenFTS)</h2>
<br clear="right">
<a href="./">ETP Documentation</a>
:ETP Search
<h3>Using OpenFTS Search and ETP</h3>
<p>The Edit-this-page package will automatically register a Search
FtsContentProvider service contract for any new content types that
are defined using etp::define_application.</p>
<p>By default it will allow indexing of the title, content, and
description attributes of an item. To add indexing of custom
content_type attributes a developer creates a specially named Tcl
proc: <code>etp::search::content_type where <em>content_type</em>
is the customer content type you have created. For a sample Tcl
proc see edit-this-page/tcl/etp-sc-procs.tcl for
etp::search::etp_page_revision. The calling proc will pass in an
array name. The custom search proc should modify the passed in
array using upvar as per the example. The elements of that array
will include: object_id, title, content, mime_type, keywords, and
storage_type. The custom search proc should only modify the title,
content, and keywords elements of the array. The etp::search
namespace must be used to define the Tcl Proc.</code>
</p>
<p><code>Sample Tcl Proc:</code></p>
<pre><code>      namespace eval etp::search {}

ad_proc etp::search::etp_page_revision {
    {-array_name ""}
} {
    Sample Custom content type search proc
    We are allowed to add/modify the elements for the
    search compatible datasource array via upvar
} {
    if {[exists_and_not_null array_name]} {
        upvar search_array $array_name
        ns_log notice "ETP:search:etp_page_revision
    arrayname:$array_name"
        # this proc would modify the "search_array" array
        # valid elements include search_array(title),
        # search_array(content), and search_array(keywords)
    }
}</code></pre>
<p><code>To add previosuly created items to the search index
execute the following query in psql:</code></p>
<pre><code>insert into search_observer_queue
(select revision_id, 
        current_timestamp, 
        'INSERT' 
 from cr_revisions r,
      cr_items i 
 where r.item_id=i.item_id 
   and i.content_type='etp_page_revision' 
   and r.revision_id = i.live_revision);
</code></pre>
<hr>
<address><code><a href="mailto:dave\@thedesignexperience.org">Dave
Bauer</a></code></address>
<!-- Created: Mon Jan 27 11:12:57 EST 2003 --><!-- hhmts start --><code>Last modified: Mon Jan 27 11:25:38 EST 2003 
<!-- hhmts end -->
</code>
