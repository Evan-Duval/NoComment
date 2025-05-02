import { Routes } from '@angular/router';

// Auth : 
import { LoginComponent } from './pages/auth/login/login.component';
import { RegisterComponent } from './pages/auth/register/register.component';

// Bottom components :
import { ProfilComponent } from './pages/profil/profil.component';
import { SettingsComponent } from './pages/settings/settings.component';

// Groups :
import { GroupsComponent } from './pages/groups/groups.component';
import { CreateGroupComponent } from './pages/groups/create/create.component';
import { GroupViewComponent } from './pages/groups/group-view/group-view.component';

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
  { path: 'profil', component: ProfilComponent },
  { path: 'settings', component: SettingsComponent },
  { path: 'groups', component: GroupsComponent },

  // Sous-pages :
  { path: 'groups/create', component: CreateGroupComponent }, 
  { path: 'groups/view/:id', component: GroupViewComponent }
];