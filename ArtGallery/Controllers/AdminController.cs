﻿using System;
using System.IO;
using System.Web;
using System.Web.Mvc;
using System.Web.WebPages;
using ArtGallery.DBaccess;
using ArtGallery.Models;
using ArtGallery.ViewModels;
using Microsoft.Ajax.Utilities;
using PagedList;

namespace ArtGallery.Controllers
{
    public class AdminController : Controller
    {

        AdminViewModel admin = new AdminViewModel();

        ArtifexContext db = new ArtifexContext();
        // GET: Admin

        public ActionResult Index()
        {
            //hard coded temporarly
            admin = new AdminViewModel();
            admin.Admin.Name = "nice man";
            return View(admin);
        }

        public ActionResult Orders(string Orderby, int? page, string sortdir)
        {
            if (Request.QueryString["table_search"].IsNullOrWhiteSpace() ||
                !Request.QueryString["table_search"].IsInt())
            {
                sortdir = sortdir == "desc" ? "asc" : "desc";
                bool asc = sortdir == "desc" ? true : false;
                if (Orderby == "OrderDate")
                {
                    admin.Orders = db.GetSortedOrders("ORDER_DATE", asc).ToPagedList(page ?? 1, 5);
                    return View(admin);
                }
                else if (Orderby == "deliveryDate")
                {
                    admin.Orders = db.GetSortedOrders("DELIVERY_DATE", asc).ToPagedList(page ?? 1, 5);
                    return View(admin);
                }
                else
                {
                    admin.Orders = db.GetSortedOrders("STATUS", asc).ToPagedList(page ?? 1, 5);
                    return View(admin);
                }
            }
            else
            {
                admin.Orders = db.GetOrderById(Convert.ToInt32(Request.QueryString["table_search"]))
                    .ToPagedList(page ?? 1, 5);
                return View(admin);
            }
        }

        public ActionResult Reports(string Orderby, int? page, string sortdir)
        {
            if (Request.QueryString["table_search"].IsNullOrWhiteSpace() ||
                !Request.QueryString["table_search"].IsInt())
            {
                sortdir = sortdir == "desc" ? "asc" : "desc";
                bool asc = sortdir == "desc" ? true : false;
                if (Orderby == "UserName")
                {
                    admin.Reports = db.GetSortedReports("USER_NAME", asc).ToPagedList(page ?? 1, 5);
                    return View(admin);
                }
                else if (Orderby == "OrderId")
                {
                    admin.Reports = db.GetSortedReports("ORDER_ID", asc).ToPagedList(page ?? 1, 5);
                    return View(admin);
                }
                else
                {
                    admin.Reports = db.GetSortedReports("ADMIN_ID", asc).ToPagedList(page ?? 1, 5);
                    return View(admin);
                }
            }
            else
            {
                admin.Reports = db.GetReportById(Convert.ToInt32(Request.QueryString["table_search"]))
                    .ToPagedList(page ?? 1, 5);
                return View(admin);
            }
        }

        public ActionResult Proposals(string Orderby, int? page, string sortdir)
        {
            if (Request.QueryString["table_search"].IsNullOrWhiteSpace())
            {
                sortdir = sortdir == "desc" ? "asc" : "desc";
                bool asc = sortdir == "desc" ? true : false;
                if (Orderby == "Artist")
                {
                    admin.Artworks = db.GetSortedProposedArtworks("ARTIST_UNAME", asc).ToPagedList(page ?? 1, 5);
                    return View(admin);
                }
                else if (Orderby == "Category")
                {
                    admin.Artworks = db.GetSortedProposedArtworks("CATEGORY_NAME", asc).ToPagedList(page ?? 1, 5);
                    return View(admin);
                }
                else if (Orderby == "Title")
                {
                    admin.Artworks = db.GetSortedProposedArtworks("TITLE", asc).ToPagedList(page ?? 1, 5);
                    return View(admin);
                }
                else if (Orderby == "Price")
                {
                    admin.Artworks = db.GetSortedProposedArtworks("Price", asc).ToPagedList(page ?? 1, 5);
                    return View(admin);
                }
                else
                {
                    admin.Artworks = db.GetSortedProposedArtworks("AW_CODE", asc).ToPagedList(page ?? 1, 5);
                    return View(admin);
                }
            }
            else
            {
                admin.Artworks = db.GetProposedArtworksByArtist(Request.QueryString["table_search"])
                    .ToPagedList(page ?? 1, 5);
                return View(admin);
            }
        }

        public ActionResult ProposalsAction(int? code)
        {
            if (code == null)
                return HttpNotFound();
            admin.Artwork = db.GetArtworkWithCode((int) code);
            if (admin.Artwork.ADMIN_ID != null)
                return HttpNotFound();
            else
                return View(admin);
        }

        [HttpPost]
        public ActionResult ProposalsAction(string code)
        {
            if (Request.Form["Approve"] != null)
            {
                //should be updated with admin code later
                if (!db.ApproveArtwork(1, Convert.ToInt32(code), 1))
                    return HttpNotFound();

            }
            else
            {
                if (!db.ApproveArtwork(1, Convert.ToInt32(code), 0))
                    return HttpNotFound();

            }

            return RedirectToAction("Proposals");
        }

        public ActionResult Event()
        {
            //temporary

            return View();
        }

        [HttpPost]
        public ActionResult Event(Event e)
        {
            if (ModelState.IsValid)
            {
                //temporary for testing will not be hardcoded later
                e.ADMIN_ID = 1;
                if (e.imagefile != null)
                {
                    string imagefilename = Path.GetFileNameWithoutExtension(e.imagefile.FileName);
                    string extension = Path.GetExtension(e.imagefile.FileName);
                    imagefilename = imagefilename + DateTime.Now.ToString("yymmssfff") + extension;
                    e.imagefile.SaveAs(Path.Combine(Server.MapPath("~/Images/"), imagefilename));
                    e.IMAGE = "~/Images/" + imagefilename;
                }
                else
                {
                    e.IMAGE = "~/Images/defaul.png";
                }

                if (db.CreateEvent(e))
                    return RedirectToAction("Index");
                else
                    return HttpNotFound();
            }
            else
            {
                return View(e);
            }

        }

        public ActionResult EditEvent(string EventTitle)
        {

            Event e = db.GetEventInfo(EventTitle)[0];
            return View(e);
        }

        [HttpPost]
        [ActionName("EditEvent")]
        public ActionResult editEvent(Event e, string old)
        {

            if (ModelState.IsValid)
            {
                //temporary for testing will not be hardcoded later
                e.ADMIN_ID = 1;
                if (e.imagefile != null)
                {
                    string imagefilename = Path.GetFileNameWithoutExtension(e.imagefile.FileName);
                    string extension = Path.GetExtension(e.imagefile.FileName);
                    imagefilename = imagefilename + DateTime.Now.ToString("yymmssfff") + extension;
                    e.imagefile.SaveAs(Path.Combine(Server.MapPath("~/Images/"), imagefilename));
                    e.IMAGE = "~/Images/" + imagefilename;
                }
                else
                {
                    e.IMAGE = "~/Images/defaul.png";
                }

                if (db.EditEvent(e, old))
                    return RedirectToAction("Index");
                else
                    return HttpNotFound();
            }
            else
            {
                return View(e);
            }

        }

        public ActionResult ViewEvents(int? page)
        {
            IPagedList<Event> events = db.GetEvents().ToPagedList(page ?? 1, 5);
            return View(events);

        }
    }
}