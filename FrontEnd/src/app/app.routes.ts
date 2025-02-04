import { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';

export const routes: Routes = [
  // Redirection de la route vide vers home
  { path: '', redirectTo: '/home', pathMatch: 'full' },
  // Route pour la page d'accueil
  { path: 'home', component: HomeComponent }
];