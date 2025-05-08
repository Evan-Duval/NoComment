import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { GroupService } from '../../services/group.service';
import { UserService } from '../../services/user.service';

@Component({
  selector: 'app-groups',
  imports: [CommonModule],
  templateUrl: './groups.component.html',
  styleUrl: './groups.component.css'
})
export class GroupsComponent implements OnInit {
  groups: any[] = [];
  userToken: string | null = localStorage.getItem('token');
  userId: number = 0;

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
        }
      });
    }
  }

  loadGroups(): void {
    this.groupService.getGroupsByUser(this.userId).subscribe({
      next: (data) => {
        this.groups = data;
      },
      error: (error) => {
        console.error('Erreur lors de la récupération des groupes', error);
      }
    });
  }

  redirectToCreate(): void {
    this.router.navigate(['/groups/create']);
  }

  redirectToGroup(groupId: number): void {
    this.router.navigate([`/groups/view/${groupId}`]);
  }
  
}
