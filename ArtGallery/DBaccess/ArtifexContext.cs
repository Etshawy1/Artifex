﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;
using System.Linq;
using System.Web;
using ArtGallery.Models;
using ArtGallery.ViewModels;
using BBMS.db_access;

namespace ArtGallery.DBaccess
{
    public class ArtifexContext: DbContext
    {
        private DBManager db = new DBManager();
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }

        public int SignUp(RegisterViewModel u)
        {
            string query = "insert into [USER] values ('" + u.USER_NAME + "', '" + u.EMAIL + "','" +
                           u.PASSWORD + "', '" + u.FNAME + "', '" + u.MINIT + "', '" + u.LNAME + "', '" +
                           u.PHONE + "', '" + u.PROFILE_PIC + "')";
            return  db.ExecuteNonQuery(query);
        }
        public DataTable SignIn(LoginViewModel u)
        {
            string query = "SELECT*" +
                "FROM[dbo].[USER]" +
                "WHERE EMAIL = '" + u.email +
                "' AND PASSWORD = '" + u.password + "';";
            return db.ExecuteReader(query);
        }
    }

    
    

}

