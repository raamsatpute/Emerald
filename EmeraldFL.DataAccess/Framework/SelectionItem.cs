using EmeraldFL.DataAccess.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EmeraldFL.DataAccess.Framework
{
    public class SelectionItem
    {
        public int Id { get; set; }

        public string Name { get; set; }

    }

    public class SelectListItem
    {
        public int Value { get; set; }

        public string Text { get; set; }

    }

    public class SelectListItem<T>
    {
        public T Value { get; set; }

        public string Text { get; set; }

    }
}
