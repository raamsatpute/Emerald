using System;
using System.Configuration;
using System.Runtime.Caching;

namespace EmeraldFL.DataAccess
{
    public interface IGlobalCachingProvider
    {
        void AddItem(string key, object value, CacheItemPolicy policy);
        void AddItem(string key, object value);
        object GetItem(string key);
        object GetItem(string key, bool remove);
    }

    public abstract class CachingProviderBase
    {
        public const int Hour = 60 * 60 * 60;

        protected MemoryCache Cache = new MemoryCache("CachingProvider");

        static readonly object Padlock = new object();

        public virtual void AddItem(string key, object value, CacheItemPolicy policy)
        {
            lock (Padlock)
            {
                Cache.Set(key, value, policy);
            }
        }
        public  virtual void AddItem(string key, object value)
        {
            CacheItemPolicy policy = new CacheItemPolicy();
            policy.AbsoluteExpiration = GetCachePolicyOffset();
            AddItem(key,value, policy);
        }

        public virtual void RemoveItem(string key)
        {
            lock (Padlock)
            {
                Cache.Remove(key);
            }
        }

        public virtual object GetItem(string key, bool remove)
        {
            lock (Padlock)
            {
                var res = Cache[key];

                if (res != null)
                {
                    if (remove == true)
                        Cache.Remove(key);
                }
                return res;
            }
        }

        public virtual object GetItem(string key)
        {
            return GetItem(key, false);//Remove default is true because it's Global Cache!
        }

        public virtual T GetItem<T>(string key) where T : class
        {
            return GetItem(key, false) as T;//Remove default is true because it's Global Cache!
        }


        public virtual bool Contains(string key)
        {
            return Cache.Contains(key);
        }

        public virtual DateTimeOffset GetCachePolicyOffset()
        {
            int policyLength = 0;
            if (!int.TryParse(ConfigurationManager.AppSettings["CacheLengthInSeconds"], out policyLength))
                policyLength = 600;

            return GetCachePolicyOffset(policyLength);
        }

        public virtual DateTimeOffset GetCachePolicyOffset(int cacheLengthInSeconds)
        {
            return DateTimeOffset.Now.AddSeconds(cacheLengthInSeconds);
        }


    }
}