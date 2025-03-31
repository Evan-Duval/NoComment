import { Component, OnInit } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { CommonModule } from '@angular/common';
import { GroupService } from '../services/group.service';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [RouterLink, RouterLinkActive, CommonModule],
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.css'
})
export class SidebarComponent implements OnInit {
  groups: any[] = [];
  userId: number = 1;
  showCreateButton: boolean = false;

  constructor(private groupService: GroupService) {}

  ngOnInit(): void {
    this.groupService.getGroupsByUser(this.userId).subscribe(
      data => {
        this.groups = data;
        this.showCreateButton = this.groups.length === 0;
      },
      error => {
        console.error('Erreur lors de la récupération des groupes', error);
      }
    );
  }
}
