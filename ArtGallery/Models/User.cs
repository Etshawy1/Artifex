﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.ComponentModel;

namespace ArtGallery.Models
{
    public class User
    {

        [Required( ErrorMessage ="Please enter your email")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessage = "Please enter a valid e-mail address")]
        public string email { get; set; }

        [Required(ErrorMessage = "Please enter your user name")]
        [RegularExpression("^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$", ErrorMessage = "Please enter a valid user name")]
        public string username { get; set; }

        [Required(ErrorMessage = "Please enter your password")]
        [DataType(DataType.Password)]
        [RegularExpression("^(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$", ErrorMessage = "Invalid password format")]
        public string password { get; set; }


        [Required(ErrorMessage = "Please enter your middle name")]
        [StringLength(2, ErrorMessage = "Max length = 2 characters")]
        [RegularExpression("^[a-zA-Z]", ErrorMessage = "Please enter a valid minit it is one char and only letters are allowed")]
        public string minit { get; set; }

        [Required(ErrorMessage = "Please enter your first name")]
        [StringLength(15, ErrorMessage = "Max length = 15 characters")]
        [RegularExpression("^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$", ErrorMessage = "Only letters are allowed")]
        public string fname { get; set; }

        [Required(ErrorMessage = "Please enter your last name")]
        [StringLength(15, ErrorMessage = "Max length = 15 characters")]
        [RegularExpression("^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$", ErrorMessage = "Only letters are allowed")]
        public string lname { get; set; }

        [Required(ErrorMessage = "Please enter your phone number")]
        [RegularExpression("01[0-9]{9}", ErrorMessage = "The phone number must be in format 01020809076")]
        public string phone { get; set; }
        public string imagepath { get; set; }
        public HttpPostedFileBase imagefile { get; set; }

    }
}