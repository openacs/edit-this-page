<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="create_folder">
<querytext>
   begin
     :1 := content_folder.new(
              name        => :name,
              label       => :title,
              description => '',
              parent_id   => etp.get_folder_id(:parent_package_id)
           );
   end;
</querytext>
</fullquery>

<fullquery name="register_types">
    <querytext>
      select
      content_folder.register_content_type(:folder_id,'content_revision','t')
    </querytext>
</fullquery>

<fullquery name="register_folders">
    <querytext>
      select
      content_folder.register_content_type(:folder_id,'content_folder','f')
    </querytext>
</fullquery>

<fullquery name="get_section_name">
<querytext>
   select acs_object.name(:package_id) as title from dual
</querytext>
</fullquery>

</queryset>
