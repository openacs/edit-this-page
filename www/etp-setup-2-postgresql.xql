<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="create_folder">
<querytext>
select content_folder__new(:name, :title, '', coalesce(etp__get_folder_id(:parent_package_id), NULL));
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
