<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="create_folder">
<querytext>
select content_folder.new(:name, :title, '', etp_get_folder_id(:parent_package_id));
</querytext>
</fullquery>
 
<fullquery name="get_section_name">
<querytext>
select acs_object.name(:package_id) as title
</querytext>
</fullquery>

</queryset>
