<master>
<property name="title">@title@</property>
<if @context_bar@ not nil>
<property name="context_bar">@context_bar@</property>
</if>
<else>
<property name="context">@context@</property>
</else>

<slave>

<if @etp_link@ not nil>
<table width="100%">
<tr><td align="right">@etp_link@</td></tr>
</table>
</if>
