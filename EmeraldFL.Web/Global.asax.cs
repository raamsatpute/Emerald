using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.Http;
using System.IO;
using System.Diagnostics; 

namespace EmeraldFL.Web
{
    public class Global : System.Web.HttpApplication
    {

        private Stopwatch sw = null;
        private Int32 Count = 0;

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            //sw = Stopwatch.StartNew();
        }

        protected void Application_EndRequest(object sender, EventArgs e)
        {
            if (sw != null)
            {
                //sw.Stop();
                //Response.Write("Estimated Time (in second): " + sw.Elapsed.TotalSeconds.ToString("0.#######"));
            }
        }
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            log4net.Config.XmlConfigurator.Configure(new FileInfo(Server.MapPath("~/Web.config")));
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
        }

        protected void Application_PreRequestHandlerExecute(object sender, EventArgs e)
        {
            //if (HttpContext.Current.Request.Url.AbsolutePath.Contains("Registration/ChangePassword.aspx") && Count == 0)
            //{
            //    Count = Count + 1;
            //    Response.Redirect("~/Registration/ChangePassword.aspx");
            //}

            //if ((Context.Handler is IRequiresSessionState || Context.Handler is IReadOnlySessionState) && Count == 0)
            if ((Context.Handler is IRequiresSessionState || Context.Handler is IReadOnlySessionState) && Count == 0)
            {
                VerifyRequestedURL();
            }

            //VerifyRequestedURLOld();


        }


        private void VerifyRequestedURL()
        {

            //if (Session["UserLocation"] == null)
            //{
            //    if (!HttpContext.Current.Request.Url.AbsolutePath.Contains("login.aspx"))
            //    {
            //        Response.Redirect("~/account/login.aspx");
            //    }
            //}

            //if (Request.QueryString["LocId"] != null)
            if (Request.QueryString["SpecId"] != null)
            {

                if (HttpContext.Current.Request.Url.AbsolutePath.Contains("specentry.aspx"))
                {
                    string LocID = Request.QueryString["LocId"];
                    string LocGroup = Request.QueryString["LocGr"];
                    Session["UserLocation"] = LocID;
                    Session["ssuseridnum"] = "315";//Staging 212,Production 315
                    Session["UserLocGroup"] = LocGroup;
                    Session["ssgid"] = Guid.NewGuid();
                    //Session("ssuseridnum") = "315";Production
                    //if(Request.QueryString["eop"] !="" && Count ==0)
                    if (Count == 0)
                    {
                        Count = Count + 1;
                        string url = HttpContext.Current.Request.Url.AbsoluteUri;
                        //Response.Redirect("~/specbook/specentry.aspx");
                        Response.Redirect(url);
                    }
                }
            }

            else if (Request.QueryString["Barcode"] != null)
            {

                if ((HttpContext.Current.Request.Url.AbsolutePath.Contains("backlog.aspx")) || (HttpContext.Current.Request.Url.AbsolutePath.Contains("TestNoPaint.aspx"))
                    || (HttpContext.Current.Request.Url.AbsolutePath.Contains("testpaintnoship.aspx")) || (HttpContext.Current.Request.Url.AbsolutePath.Contains("waitoncust.aspx")))

                {
                    string LocID = Request.QueryString["LocId"];
                    string LocGroup = Request.QueryString["LocGr"];
                    Session["UserLocation"] = LocID;
                    Session["ssuseridnum"] = "315";//Staging 212,Production 315
                    Session["UserLocGroup"] = LocGroup;
                    Session["ssgid"] = Guid.NewGuid();
                    //Session("ssuseridnum") = "315";Production
                    //if(Request.QueryString["eop"] !="" && Count ==0)
                    if (Count == 0)
                    {
                        Count = Count + 1;
                        string url = HttpContext.Current.Request.Url.AbsoluteUri;
                        //Response.Redirect("~/specbook/specentry.aspx");
                        Response.Redirect(url);
                    }
                }
            }

            else if (Request.QueryString["BarcodeInternal"] != null)
            {

                //if ((HttpContext.Current.Request.Url.AbsolutePath.Contains("backlog.aspx")) || (HttpContext.Current.Request.Url.AbsolutePath.Contains("TestNoPaint.aspx"))
                //    || (HttpContext.Current.Request.Url.AbsolutePath.Contains("testpaintnoship.aspx"))|| (HttpContext.Current.Request.Url.AbsolutePath.Contains("waitoncust.aspx")))

                if ((HttpContext.Current.Request.Url.AbsolutePath.Contains("backlog.aspx")) || (HttpContext.Current.Request.Url.AbsolutePath.Contains("TestNoPaint.aspx"))
                  || (HttpContext.Current.Request.Url.AbsolutePath.Contains("testpaintnoship.aspx")) || (HttpContext.Current.Request.Url.AbsolutePath.Contains("waitoncust.aspx"))
                  || (HttpContext.Current.Request.Url.AbsolutePath.Contains("unitsin02.aspx")) || (HttpContext.Current.Request.Url.AbsolutePath.Contains("Warranty.aspx"))
                  || (HttpContext.Current.Request.Url.AbsolutePath.Contains("Summary.aspx"))
                  || (HttpContext.Current.Request.Url.AbsolutePath.Contains("PCB.aspx"))
                  )


                {
                    string LocID = Request.QueryString["LocId"];
                    string LocGroup = Request.QueryString["LocGr"];
                    string UserId= Request.QueryString["UserId"];
                    Session["UserLocation"] = LocID;
                    //Session["ssuseridnum"] = "315";//Staging 212,Production 315
                    Session["ssuseridnum"] = UserId;//Staging 212,Production 315
                    Session["UserLocGroup"] = LocGroup;
                    Session["ssgid"] = Guid.NewGuid();
                    //Session("ssuseridnum") = "315";Production
                    //if(Request.QueryString["eop"] !="" && Count ==0)
                    if (Count == 0)
                    {
                        Count = Count + 1;
                        string url = HttpContext.Current.Request.Url.AbsoluteUri;
                        //Response.Redirect("~/specbook/specentry.aspx");
                        Response.Redirect(url);
                    }
                }
            }

            else
            {
                if (Session["UserLocation"] == null)
                {
                    if (!HttpContext.Current.Request.Url.AbsolutePath.Contains("login.aspx"))
                    {
                        Response.Redirect("~/account/login.aspx");
                    }
                }

            }
        }
        /// <summary>
        /// throws to login page if attempt made to access any other page without login.
        /// </summary>
        private void VerifyRequestedURLb()
        {



            //if (Session["UserLocation"] == null)
            //{
            //    if (!HttpContext.Current.Request.Url.AbsolutePath.Contains("login.aspx"))
            //    {
            //        if (HttpContext.Current.Request.Url.AbsolutePath.Contains("Registration/ChangePassword.aspx"))
            //        {
            //            Response.Redirect("~/Registration/ChangePassword.aspx");
            //        }
            //        else
            //        {
            //            Response.Redirect("~/account/login.aspx");
            //        }
            //    }
            //}

            //if (Session["UserLocation"] == null)
            //{
            //    if (!HttpContext.Current.Request.Url.AbsolutePath.Contains("login.aspx"))
            //    {
            //        Response.Redirect("~/account/login.aspx");
            //    }
            //}
            //if (Session["UserLocation"] == null)
            //{
            //    if (!HttpContext.Current.Request.Url.AbsolutePath.Contains("login.aspx"))
            //    {

            //        Request.QueryString["eop"] = "eop";
            //        Response.Redirect("~/account/login.aspx");
            //    }
            //}


            //last
            //if (Session["UserLocation"] == null)
            //{
            //    if (!HttpContext.Current.Request.Url.AbsolutePath.Contains("login.aspx"))
            //    {
            //        if (HttpContext.Current.Request.Url.AbsolutePath.Contains("Registration/ChangePassword.aspx"))
            //        {
            //            Response.Redirect("~/account/login.aspx?eop=eop");
            //        }
            //        else
            //        {
            //            Response.Redirect("~/account/login.aspx");
            //        }
            //    }

            //    string a = Request.QueryString[""];
            //}


            if (Session["UserLocation"] == null)
            {
                if (!HttpContext.Current.Request.Url.AbsolutePath.Contains("login.aspx"))
                {
                    //if (HttpContext.Current.Request.Url.AbsolutePath.Contains("registration/changepassword.aspx"))
                    if (HttpContext.Current.Request.Url.AbsolutePath.Contains("ChangePassword.aspx"))
                    {
                        //if(Request.QueryString["eop"] !="" && Count ==0)
                        if (Count == 0)
                        {
                            Count = Count + 1;
                            Response.Redirect("~/registration/changepassword.aspx");
                        }
                    }
                    else if (HttpContext.Current.Request.Url.AbsolutePath.Contains("specentry.aspx"))
                    {
                        //http://staging.gold.operations.emeraldtransformer.com/specbook/specentry.aspx?SpecId=97&LocId=1&LocGr=FL

                        string LocID = Request.QueryString["LocId"];
                        string LocGroup = Request.QueryString["LocGr"];
                        string userid = Request.QueryString["userid"];
                        Session["UserLocation"] = LocID;
                        Session["ssuseridnum"] = "315";//Staging
                        Session["UserLocGroup"] = LocGroup;

                        //Session("ssuseridnum") = "315";Production
                        //if(Request.QueryString["eop"] !="" && Count ==0)
                        if (Count == 0)
                        {
                            Count = Count + 1;
                            string url = HttpContext.Current.Request.Url.AbsoluteUri;
                            //Response.Redirect("~/specbook/specentry.aspx");
                            //Response.Redirect(url);
                        }
                    }
                    else
                    {
                        Response.Redirect("~/account/login.aspx");
                    }
                }

                string a = Request.QueryString[""];
            }

            //if (Session["UserLocation"] == null)
            //{
            //    if (!HttpContext.Current.Request.Url.AbsolutePath.Contains("Registration/ChangePassword.aspx"))
            //    {
            //        Session["ChangePassword"] = "CP";
            //        Response.Redirect("~/account/login.aspx");

            //    }


            //    //    else if (HttpContext.Current.Request.Url.AbsolutePath.Contains("Registration/ChangePassword.aspx"))
            //    //    {
            //    //        Response.Redirect("~/Registration/ChangePassword.aspx");
            //    //    }
            //}
        }

        protected void Application_AuthenticateRequest(object sender, System.EventArgs e)
        {
            Uri ReqUrl = HttpContext.Current.Request.Url;
            string[] ReqSegmeent = ReqUrl.Segments;
            string RequestPage = ReqSegmeent[ReqSegmeent.Length - 1];

            // if the requested  page is "SkippedFromAuthorization.aspx" , we skip the Authenticatation
            // you should replace the "SkippedFromAuthorization.aspx" with the page name that you want to skip 
            if ((RequestPage.ToLower() == "ChangePassword.aspx".ToLower()))
                HttpContext.Current.SkipAuthorization = true;
        }

        private void VerifyRequestedURLOld()
        {

            if (HttpContext.Current.Request.Url.AbsolutePath.Contains("Registration/ChangePassword.aspx"))
            {
                Response.Redirect("~/Registration/ChangePassword.aspx");
            }

        }

        private void VerifyRequestedURLOlda()
        {
            if (Session["UserLocation"] == null)
            {
                if (HttpContext.Current.Request.Url.AbsolutePath.Contains("Registration/ChangePassword.aspx"))
                {
                    Response.Redirect("~/Registration/ChangePassword.aspx");
                }


                else if (!HttpContext.Current.Request.Url.AbsolutePath.Contains("login.aspx"))
                {
                    Response.Redirect("~/account/login.aspx");
                }
            }
        }
    }
}