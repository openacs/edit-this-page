<master src="etp-master">
<property name="doc(title)">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<table width="100%">
  <tr>
    <th align="left">#edit-this-page.Version#
    <th align="left">#edit-this-page.Created#
    <th align="left">#edit-this-page.Published#
    <th align="left">
  </tr>
  <multiple name="revisions">
    <tr>
      <td valign="top">
        <if @revisions.revision_id@ eq @live_revision_id@>
          <b>@revisions.version_number@</b> #edit-this-page.LIVE#
        </if>
        <else>
          @revisions.version_number@
        </else>
      </td>
      <td valign="top">
        <if @revisions.creation_user_name@ not nil>
        <a href="/shared/community-member?user_id=@revisions.creation_user_id@">
        @revisions.creation_user_name@</a> #edit-this-page.on#
        </if>
        @revisions.creation_date@
      </td>
      <td valign="top">
        <if @revisions.publish_user_name@ not nil>
        <a href="/shared/community-member?user_id=@revisions.publish_user_id@">
        @revisions.publish_user_name@</a> #edit-this-page.on#
        </if>
        @revisions.publish_date@ 
      </td>
      <td valign="top" align="right">
        <a href="@name@?revision_id=@revisions.revision_id@">#edit-this-page.view#</a>
        <if @revisions.revision_id@ lt @live_revision_id@>
         | <a href="etp-revert?name=@name@&revision_id=@revisions.revision_id@&version_number=@revisions.version_number@">#edit-this-page.revert#</a>
        </if> 
        <if @revisions.revision_id@ gt @live_revision_id@>
         | <a href="etp-revision-delete?name=@name@&revision_id=@revisions.revision_id@&version_number=@revisions.version_number@">#edit-this-page.delete#</a>
        </if> 
      </td>
    </tr>
  </multiple>
</table>

