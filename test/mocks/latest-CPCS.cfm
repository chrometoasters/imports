<cfparam name="title" default="0">
<cfparam name="types" default="0">
<cfparam name="areas" default="0">
<cfparam name="Published" default="0">
<cfparam name="Link" default="">
  <cfquery name="CPCS" datasource="techlink">
    select * from TechSearch where Published = 1 and Types = 'Classroom Practice Case Study'
    order by PublicationDate desc
  </cfquery>

 <p class="subsubhead" style="margin-bottom:6px;">Recent Classroom Practice Case Studies</p>

<cfoutput query="CPCS" startrow="1" maxrows="4">
  <div style="width:450px; padding:0px; margin:0 0 11px 0; height:80px;">
    <cfif #image# is not "">
      <a href="#link#" target="_blank" title="#title#" ><img src="/latest-news/news-images/#image#" alt="#title# image" width="115" height="80" border="1" class="FloatLeft" /></a>
      <p style="padding-left:55px; padding-top:3px;">
      <cfelse><p style="padding-left:0px;">
    </cfif>
      <strong>
        <a href="#link#" target="_blank" style="color:##333;"><cfif #len(Title)# gt 28>#titleshort#<cfelse>#title#</cfif></a>
      </strong> <br />
      <cfif #len(Descriptionshort)# gt 200>#removechars(Descriptionshort, 200, 2000)#...
      <cfelse>#Descriptionshort#</cfif> <a href="#link#" target="_blank">More<span style="margin-left:3px;">&raquo;</span></a>
    </p>
  </div>
</cfoutput>
