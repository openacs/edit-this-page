<master src="etp-master">
<property name="title">@page_title@</property>
<property name="context_bar">@context_bar@</property>

<table width="100%"><tr>
<td valign="top">
<a href="@page_url@">@page_url@</a> 
<td valign="top">
version @pa.latest_revision@
(live version is @pa.live_revision@)
<td valign="top" align="right">
<if @edit_parent_url@ not nil>
<a href="@edit_parent_url@">Edit parent page</a>
</if>
</tr></table>
<p>

<h3>All editable attributes</h3>

<table width="100%" cellspacing="0" cellpadding="4">
<multiple name="page_attributes">
<if @page_attributes.rownum@ odd>
<tr bgcolor="#ececec">
</if>
<else>
<tr>
</else>
<td valign="top" width="12%"><b>@page_attributes.pretty_name@</b>
<td valign="top">@page_attributes.value@
<td align="right" width="12%"><a href="etp-edit?name=@pa.name@&attribute=@page_attributes.name@">edit</a>
</tr>
</multiple>
</table>

<p>

<table width="100%" cellspacing="0" cellpadding="4">
<tr>

<td valign="top">
<h3>Publishing options</h3>
<ul>
<if @pa.latest_revision@ gt @pa.live_revision@>
<li><a href="@pa.name@?revision_id=@pa.revision_id@">Preview changes</a>
<li><a href="etp-publish?name=@pa.name@">Commit your work</a> (changes will go live immediately)
</if>
<li><a href="etp-history?name=@pa.name@">View revision history</a>
</ul>
</td>

<td valign="top">
<if @pa.name@ eq "index">
<h3>Configuration of this content section</h3>
<ul>
<li><a href="etp-setup?page_title=@pa.title@">Change ETP application</a>
<!-- <li><a href="/admin/site-map/parameter-set?package_id=@package_id@">Set parameters</a> -->
<li><a href="/permissions/one?object_id=@package_id@">Set permissions</a>
<li><a href="/admin/site-map/">Site map</a>
</if>
</td>

</tr>
</table>

<p>

<if @pa.name@ eq "index">
<h3>Content items in this section</h3>
<table width="100%" cellspacing="0" cellpadding="4">
<tr bgcolor="#ececec">
<td colspan="3">
Create a new 
<a href="etp-create">@application_params.content_object_name@</a>
<if @application_params.allow_subtopics@ eq "t">
or
<a href="etp-subtopic-create">@subtopic_object_name@</a>
</if>
<if @application_params.allow_extlinks@ eq "t">
or
<a href="etp-extlink">external link</a>
</if>
<if @application_params.allow_symlinks@ eq "t">
or
<a href="etp-symlink">internal link</a>
</if>

</tr>
<multiple name="content_items">
<if @content_items.rownum@ even>
<tr bgcolor="#ececec">
</if>
<else>
<tr>
</else>
<td valign="top">@content_items.title@
<td valign="top">

<if @content_items.object_type@ eq "content_item">
(page)<td valign="top" align="right">
<a href="etp?name=@content_items.name@">edit</a>
</if>
<else>
<if @content_items.object_type@ eq "content_folder">
(subtopic)<td valign="top" align="right">
<a href="@content_items.name@/etp">edit</a></if>
<else>
<if @content_items.object_type@ eq "content_extlink">
(external&nbsp;ref)<td valign="top" align="right">
<a href="etp-extlink?item_id=@content_items.item_id@">edit</a></if>
<else>
<if @content_items.object_type@ eq "content_symlink">
(internal&nbsp;ref)<td valign="top" align="right">
<a href="etp-symlink?item_id=@content_items.item_id@">edit</a></if>
</else>
</else>
</else>

| <a href="etp-trash?item_id=@content_items.item_id@">delete</a>

<if @content_items.rownum@ ne 1>
| <a href="etp-swap?sort_order=@content_items.sort_order@">move up</a>
</if>
</td></tr>
</multiple>
</table>

</if>
