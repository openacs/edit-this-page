<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

   <partialquery name="archive_where_clause">
      <querytext>
         current_timestamp between attributes.release_date and attributes.archive_date
      </querytext>
   </partialquery>

   <partialquery name="no_archive_where_clause">
      <querytext>
         current_timestamp >= attributes.archive_date
      </querytext>
   </partialquery>

   <partialquery name="orderby_clause">
      <querytext>
         attributes.release_date desc
      </querytext>
   </partialquery>

</queryset>
