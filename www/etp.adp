<master src="etp-master">
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<table width="100%"><tr>
<td valign="top">
<a href="@page_url@">@page_url@</a> 
</td>
<td valign="top">
#edit-this-page.lt_version_palatest_revi#
</td>
<td valign="top" align="right">
<if @edit_parent_url@ not nil>
<a href="@edit_parent_url@">#edit-this-page.Edit_parent_page#</a>
</if>
</td>
</tr></table>
<p>

<h3>#edit-this-page.lt_All_editable_attributes#</h3>

<table width="100%" cellspacing="0" cellpadding="4">
<multiple name="page_attributes">
<if @page_attributes.rownum@ odd>
<tr bgcolor="#ececec">
</if>
<else>
<tr>
</else>
<td valign="top" width="12%"><b>@page_attributes.pretty_name@</b>
</td>
<if @page_attributes.name@ eq content>
<td valign="top">@page_attributes.value;noquote@
</if>
<else>
<td valign="top">@page_attributes.value@
</else>
</td>
<td align="right" width="12%"><a href="etp-edit?name=@pa.name@&attribute=@page_attributes.name@">#edit-this-page.edit#</a>
</td>
</tr>
</multiple>
</table>

<p>

<table width="100%" cellspacing="0" cellpadding="4">
<tr>

<td valign="top">
<h3>#edit-this-page.Publishing_options#</h3>
<ul>
<if @pa.latest_revision@ gt @pa.live_revision@>
<li><a href="@pa.name@?revision_id=@pa.revision_id@">#edit-this-page.Preview_changes#</a>
<li><a href="etp-publish?name=@pa.name@">#edit-this-page.Commit_your_work#</a> #edit-this-page.lt_changes_will_go_live_immediately#
</if>
<li><a href="etp-history?name=@pa.name@">#edit-this-page.lt_View_revision_history#</a>
</ul>
</td>

<td valign="top">
<if @pa.name@ eq "index">
<h3>#edit-this-page.lt_Configuration_of_this#</h3>
<ul>
<li><a href="etp-setup?page_title=@pa.title@">#edit-this-page.lt_Change_ETP_application#</a>
<!-- <li><a href="/admin/site-map/parameter-set?package_id=@package_id@">#edit-this-page.Set_parameters#</a> -->
<li><a href="/permissions/one?object_id=@package_id@">#edit-this-page.Set_permissions#</a>
<li><a href="/admin/site-map/">#edit-this-page.Site_map#</a>
</if>
</td>

</tr>
</table>

<p>

<if @pa.name@ eq "index">
<h3>#edit-this-page.lt_Content_items_in_this#</h3>
<table width="100%" cellspacing="0" cellpadding="4">
<tr bgcolor="#ececec">
<td colspan="3">
#edit-this-page.Create_a_new# 
<a href="etp-create">@application_params.content_object_name@</a>
<if @application_params.allow_subtopics@ eq "t">
#edit-this-page.or#
<a href="etp-subtopic-create">@subtopic_object_name@</a>
</if>
<if @application_params.allow_extlinks@ eq "t">
#edit-this-page.or#
<a href="etp-extlink">#edit-this-page.external_link#</a>
</if>
<if @application_params.allow_symlinks@ eq "t">
#edit-this-page.or#
<a href="etp-symlink">#edit-this-page.internal_link#</a>
</if>
</td>
</tr>
<multiple name="content_items">
<if @content_items.rownum@ even>
<tr bgcolor="#ececec">
</if>
<else>
<tr>
</else>
<td valign="top">@content_items.title@
</td>
<td valign="top">

<if @content_items.object_type@ eq "content_item">
#edit-this-page.page#</td><td valign="top" align="right">
<a href="etp?name=@content_items.name@">#edit-this-page.edit#</a>
</if>
<else>
<if @content_items.object_type@ eq "content_folder">
#edit-this-page.subtopic#</td><td valign="top" align="right">
<a href="@content_items.name@/etp">#edit-this-page.edit#</a></if>
<else>
<if @content_items.object_type@ eq "content_extlink">
#edit-this-page.external_ref#</td><td valign="top" align="right">
<a href="etp-extlink?item_id=@content_items.item_id@">#edit-this-page.edit#</a></if>
<else>
<if @content_items.object_type@ eq "content_symlink">
#edit-this-page.internal_ref#</td><td valign="top" align="right">
<a href="etp-symlink?item_id=@content_items.item_id@">#edit-this-page.edit#</a></if>
</else>
</else>
</else>

| <a href="etp-trash?item_id=@content_items.item_id@">#edit-this-page.delete#</a>

<if @content_items.rownum@ ne 1>
| <a href="etp-swap?sort_order=@content_items.sort_order@">#edit-this-page.move_up#</a>
</if>
</td></tr>
</multiple>
</table>
</if>


