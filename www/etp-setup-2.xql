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

 
</queryset>
