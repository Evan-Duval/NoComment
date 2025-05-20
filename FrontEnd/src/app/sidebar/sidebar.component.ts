import { Component, OnInit } from '@angular/core';
import { Router, RouterLink, RouterLinkActive } from '@angular/router';
import { CommonModule } from '@angular/common';
import { GroupService } from '../services/group.service';
import { UserService } from '../services/user.service';
import { SupabaseService } from '../services/supabase.service';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [RouterLink, RouterLinkActive, CommonModule],
  providers: [SidebarComponent],
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.css'
})
export class SidebarComponent implements OnInit {
  groups: any[] = [];
  userToken: string | null = localStorage.getItem('token');
  userId: number = 0;
  userRank: string = 'user';
  showCreateButton: boolean = false;
  moderationView: boolean = (localStorage.getItem('moderationView') === '1' && localStorage.getItem('token')) ? true : false;

  constructor(
    private groupService: GroupService, 
    private userService: UserService, 
    private supabaseService: SupabaseService,
    private router: Router) {}

  ngOnInit() {
    const currentUser = localStorage.getItem('currentUser') ? JSON.parse(localStorage.getItem('currentUser')!) : null;
    if (currentUser) {
      this.userId = currentUser.id!;
      this.userRank = currentUser.rank;
      this.loadGroups();
    } else {
      this.showCreateButton = true;
    }
  }

  loadGroups() {
    this.groupService.getGroupsByUser(this.userId).subscribe({
      next: (data) => {
        this.groups = data.map((group: any) => ({
          ...group,
          logoUrl: this.supabaseService.getPublicMediaUrl(group.logo)
        }));
        this.showCreateButton = this.groups.length === 0;
      },
      error: (error) => {
        console.error('Erreur lors de la récupération des groupes', error);
        this.showCreateButton = true;
      }
    });
  }

  redirectToCreate() {
    this.router.navigate(['/groups/create']);
  }

  redirectToProfile() {
    this.router.navigate(['/profil', this.userId]);
  }

  redirectToGroups() {
    this.router.navigate(['/groups']);
  }

  toggleModerationView(value: boolean) {
    if (!this.userRank || this.userRank !== 'admin' || !this.moderationView) {return;}

    this.moderationView = value;
    localStorage.setItem('moderationView', value ? '1' : '0');
    window.location.reload();
  }

  /**
   * Méthode publique pour recharger les données de la sidebar
   * Cette méthode peut être appelée de l'extérieur du composant
   */
  public reloadSidebar(): void {
    const currentUser = localStorage.getItem('currentUser') ? JSON.parse(localStorage.getItem('currentUser')!) : null;
    if (currentUser) {
      this.userId = currentUser.id!;
      this.userRank = currentUser.rank;
      this.loadGroups();
    }
    this.moderationView = (localStorage.getItem('moderationView') === '1' && localStorage.getItem('token')) ? true : false;
  }
}
