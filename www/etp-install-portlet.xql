<?xml version="1.0"?>
<queryset>

<fullquery name="site_node_name">
<querytext>

	select name
          from site_nodes
         where node_id = :node_id

</querytext>
</fullquery>

<fullquery name="set_folder_package">
<querytext>

	update cr_folders
           set package_id = :package_id
         where folder_id = :folder_id

</querytext>
</fullquery>
<fullquery name="get_parent_id">
<querytext>
        select parent_id
          from site_nodes
         where object_id = :package_id;
</querytext>
</fullquery>

<fullquery name="create_folder">
<querytext>
select content_folder__new(:name, :title, '', '0');
</querytext>
</fullquery>
<fullquery name="register_types">
    <querytext>
      select
      content_folder__register_content_type(:folder_id,'content_revision','t')
    </querytext>
</fullquery>
<fullquery name="register_folders">
    <querytext>
      select
      content_folder__register_content_type(:folder_id,'content_folder','f')
    </querytext>
</fullquery>
<fullquery name="get_section_name">
<querytext>
select acs_object__name(:package_id) as title
</querytext>
</fullquery>
 
</queryset>
