import { Routes } from '@angular/router';

// Auth : 
import { LoginComponent } from './auth/login/login.component';
import { RegisterComponent } from './auth/register/register.component';

// Pages :
import { HomeComponent } from './home/home.component';

export const routes: Routes = [
  // Redirection de base : 
  { path: '', redirectTo: 'accueil', pathMatch: 'full' },

  // Auth :
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },

  // Pages :
  { path: 'accueil', component: HomeComponent },
  { path: 'dashboard', component: HomeComponent },
  { path: 'profil', component: HomeComponent },
  { path: 'settings', component: HomeComponent }
];