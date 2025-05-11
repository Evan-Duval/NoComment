import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { GroupService } from '../services/group.service';
import { UserService } from '../services/user.service';
import { FormsModule } from '@angular/forms';

interface Post {
  author: string;
  content: string;
  timestamp: string;
  likes?: number;
  comments?: number;
}

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  groups: any[] = [];
  userToken: string | null = localStorage.getItem('token');
  userId: number = 0;
  showCreateButton: boolean = false;
  filteredGroups: any[] = [];
  searchQuery: string = '';

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
        this.filteredGroups = data;
        this.showCreateButton = this.groups.length === 0;
      },
      error: (error) => {
        console.error('Erreur lors de la récupération des groupes', error);
        this.showCreateButton = true;
      }
    });
  }

  redirectToCreate(): void {
    this.router.navigate(['/groups/create']);
  }

  posts: Post[] = [
    {
      author: 'Anaïs',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque in ante quis magna faucibus tincidunt.',
      timestamp: '2 heures',
      likes: 5,
      comments: 2
    },
    {
      author: 'Émile',
      content: 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
      timestamp: '4 heures',
      likes: 3,
      comments: 1
    }
  ];

  onSearchChange(): void {
    if (this.searchQuery.trim() === '') {
      this.filteredGroups = this.groups;
    } else {
      this.filteredGroups = this.groups.filter((group) =>
        group.name.toLowerCase().includes(this.searchQuery.toLowerCase())
      );
    }
  }
}

export default HomeComponent;