using System.Web;

namespace EmeraldFL.DataAccess.Helper
{
    public static class Helper
    {
        /// <summary>
        /// This method is to fetch logged in User location Id
        /// </summary>
        /// <returns></returns>
        public static string GetLocationIdForCurrentUser()
        {
            return HttpContext.Current.Session["UserLocation"].ToString();
        }

        /// <summary>
        /// This method is to fetch location group of logged in User
        /// </summary>
        /// <returns></returns>
        public static string GetLocationGroupForCurrentUser()
        {
            return HttpContext.Current.Session["UserLocGroup"].ToString();
        }
    }
}
