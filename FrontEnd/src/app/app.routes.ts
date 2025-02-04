import { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';

export const routes: Routes = [
  { path: '', redirectTo: 'accueil', pathMatch: 'full' },
  { path: 'accueil', component: HomeComponent },
  // Ajoutez vos autres routes ici
  { path: 'dashboard', component: HomeComponent },
  { path: 'profil', component: HomeComponent },
  { path: 'settings', component: HomeComponent }
];