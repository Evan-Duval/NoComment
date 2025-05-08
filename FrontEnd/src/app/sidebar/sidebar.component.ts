import { Component, OnInit } from '@angular/core';
import { Router, RouterLink, RouterLinkActive } from '@angular/router';
import { CommonModule } from '@angular/common';
import { GroupService } from '../services/group.service';
import { UserService } from '../services/user.service';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [RouterLink, RouterLinkActive, CommonModule],
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.css'
})
export class SidebarComponent implements OnInit {
  groups: any[] = [];
  userToken: string | null = localStorage.getItem('token');
  userId: number = 0;
  showCreateButton: boolean = false;

  constructor(private groupService: GroupService, private userService: UserService, private router: Router) {}

  ngOnInit(): void {
    // Faire l'appel API que si le token utilisateur existe (donc que la personne est login)
    if (this.userToken) {
      this.userService.getUserByToken(this.userToken).subscribe({
        next: (data) => {
          this.userId = data.id;
          
          // Récupérer les groupes seulement après avoir obtenu l'userId
          if (this.userId) {
            this.loadGroups();
          }
        },
        error: (error) => {
          console.error('Erreur lors de la récupération de l\'utilisateur', error);
          this.showCreateButton = true;
        }
      });
    } else {
      this.showCreateButton = true;
    }
  }

  loadGroups(): void {
    this.groupService.getGroupsByUser(this.userId).subscribe({
      next: (data) => {
        this.groups = data;
        this.showCreateButton = this.groups.length === 0;
      },
      error: (error) => {
        console.error('Erreur lors de la récupération des groupes', error);
        this.showCreateButton = true;
      }
    });
  }
}
