<master>
<property name="title">@title@</property>
<property name="context">@context@</property>
<h2>@title@</h2>
<%= [eval ad_context_bar $context ] %>

<hr>

<slave>
<if @etp_link@ not nil>
<table width="100%">
<tr><td align="right">@etp_link@</td></tr>
</table>
</if>
