<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="create_folder">
<querytext>
select content_folder__new(:name, :title, '', etp__get_folder_id(:parent_package_id));
</querytext>
</fullquery>
 
<fullquery name="get_section_name">
<querytext>
select acs_object__name(:package_id) as title
</querytext>
</fullquery>

</queryset>
